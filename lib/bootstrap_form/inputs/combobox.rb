# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module Combobox
      extend ActiveSupport::Concern
      include Base

      # Icons copied verbatim from the Bootstrap 6 combobox documentation.
      CARET_ICON = %(<svg class="combobox-caret" width="10" height="16" viewBox="0 0 10 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0.46967 5.46967C0.762563 5.17678 1.23744 5.17678 1.53033 5.46967L5 8.93934L8.46967 5.46967C8.76256 5.17678 9.23744 5.17678 9.53033 5.46967C9.82322 5.76256 9.82322 6.23744 9.53033 6.53033L5.53033 10.5303C5.23744 10.8232 4.76256 10.8232 4.46967 10.5303L0.46967 6.53033C0.176777 6.23744 0.176777 5.76256 0.46967 5.46967Z" fill="currentcolor"/></svg>).html_safe.freeze # rubocop:disable Layout/LineLength, Style/BarePercentLiterals
      CHECK_ICON = %(<svg class="menu-item-check" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" viewBox="0 0 16 16"><path d="m2 7 4 5 8-8"/></svg>).html_safe.freeze # rubocop:disable Layout/LineLength, Style/BarePercentLiterals

      included do
        # Bootstrap 6 combobox: a select-like control with optional search and
        # multiple selection. Bootstrap's JavaScript creates a hidden input
        # named by `data-bs-name` for form submission; with `multiple: true`
        # its value is a comma-separated list of the selected values.
        def combobox(name, choices=nil, options={}, html_options={})
          options = options.symbolize_keys
          html_options = html_options.symbolize_keys
          html_options[:id] ||= options.delete(:id) || field_id(name)
          html_options = html_options.reverse_merge(control_class: "form-control combobox-toggle")
          choices = combobox_choices(choices)

          form_group_builder(name, options, html_options) do
            combobox_content(name, choices, options, html_options)
          end
        end
      end

      private

      def combobox_content(name, choices, options, html_options)
        selected_values = combobox_selected_values(name, options)
        safe_join(
          [
            combobox_toggle(name, choices, selected_values, options, html_options),
            combobox_menu(choices, selected_values, options),
            generate_error(name, html_options[:id])
          ].compact
        )
      end

      def combobox_choices(choices)
        Array(choices).map do |choice|
          choice.is_a?(Array) ? [choice.first.to_s, choice.last] : [choice.to_s, choice]
        end
      end

      def combobox_selected_values(name, options)
        selected = options.key?(:selected) ? options[:selected] : object&.send(name)
        Array(selected).map(&:to_s)
      end

      def combobox_toggle(name, choices, selected_values, options, html_options)
        tag.button(
          type: "button",
          class: html_options[:class],
          id: html_options[:id],
          data: combobox_toggle_data(name, options).merge(html_options[:data].to_h),
          aria: { haspopup: "listbox", expanded: "false" }.merge(html_options[:aria].to_h)
        ) do
          labels = choices.select { |_text, value| selected_values.include?(value.to_s) }.map(&:first)
          combobox_value(labels, options[:placeholder]) + CARET_ICON
        end
      end

      def combobox_toggle_data(name, options)
        {
          bs_toggle: "combobox",
          bs_name: options[:name] || field_name(name),
          bs_placeholder: options[:placeholder],
          bs_multiple: ("true" if options[:multiple]),
          bs_search: ("true" if options[:search])
        }.compact
      end

      # The toggle shows the selected value, or the count when more than one
      # item is selected, mirroring Bootstrap's combobox JavaScript.
      def combobox_value(labels, placeholder)
        if labels.empty?
          tag.span(placeholder, class: "combobox-value combobox-placeholder")
        elsif labels.one?
          tag.span(labels.first, class: "combobox-value")
        else
          tag.span("#{labels.count} selected", class: "combobox-value")
        end
      end

      def combobox_menu(choices, selected_values, options)
        items = choices.map do |text, value|
          combobox_menu_item(text, value, selected: selected_values.include?(value.to_s), multiple: options[:multiple])
        end
        if options[:search]
          items.prepend(combobox_search(options[:search]))
          items.append(tag.div("No results found", class: "combobox-no-results d-none"))
        end
        tag.div(safe_join(items), class: "menu")
      end

      def combobox_menu_item(text, value, selected:, multiple:)
        tag.button(
          type: "button",
          class: ["menu-item", ("selected" if selected)].compact,
          data: { bs_value: value },
          aria: ({ selected: "true" } if selected)
        ) do
          multiple ? safe_join([text, CHECK_ICON]) : text
        end
      end

      def combobox_search(search)
        placeholder = search.is_a?(String) ? search : "Search…"
        tag.div(class: "combobox-search") do
          tag.input(type: "text", class: "form-control combobox-search-input",
                    placeholder: placeholder, autocomplete: "off", aria: { label: placeholder })
        end
      end
    end
  end
end
