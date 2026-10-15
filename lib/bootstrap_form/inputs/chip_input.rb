# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module ChipInput
      extend ActiveSupport::Concern
      include Base

      # Bootstrap's default dismiss icon, copied from its chips component.
      DISMISS_ICON = %(<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="4" y1="4" x2="12" y2="12"/><line x1="12" y1="4" x2="4" y2="12"/></svg>).html_safe.freeze # rubocop:disable Layout/LineLength, Style/BarePercentLiterals

      included do
        # Bootstrap 6 chip input: existing values are rendered as chips in a
        # `chip-input` container with a `form-ghost` text input for adding
        # more. Configuration goes in the `:chips` option and is rendered as
        # `data-bs-*` attributes, e.g. `chips: { separator: ",", max_chips: 5 }`;
        # `class:` adds container classes such as a theme. Bootstrap's JavaScript
        # has no form-submission integration for chips, so read the values with
        # its `getValues()` API or sync them to a hidden field yourself.
        def chip_input(name, options={})
          options = options.symbolize_keys
          chips_options = options.delete(:chips).to_h.symbolize_keys
          values = chip_values(name, options.delete(:values), chips_options)
          options[:id] ||= field_id(name, namespace: nil)
          options = options.reverse_merge(control_class: "form-ghost")
          form_group_builder(name, options) do
            chip_container(name, values, chips_options, options)
          end
        end
      end

      private

      def chip_values(name, values, chips_options)
        values = object.try(name) if values.nil?
        separator = chips_options.fetch(:separator, ",")
        Array(values).flat_map { |value| value.is_a?(String) && separator ? value.split(separator) : value }
                     .map { |value| value.to_s.strip }.compact_blank
      end

      def chip_container(name, values, chips_options, options)
        classes = ["chip-input", chips_options.delete(:class)].compact
        dismissible = chips_options[:dismissible] != false
        container = tag.div(class: classes, data: chip_data(chips_options)) do
          safe_join(values.map { |value| chip(value, dismissible:) } + [chip_ghost_input(options)])
        end
        safe_join([container, generate_error(name, options[:id])].compact)
      end

      def chip(value, dismissible:)
        dismiss = tag.button(DISMISS_ICON, type: "button", class: "chip-dismiss", aria: { label: "Remove" }) if dismissible
        tag.span(safe_join([value, dismiss].compact), class: "chip", data: { bs_chip_value: value })
      end

      def chip_ghost_input(options)
        tag.input(type: "text", id: namespaced_id(options[:id]), class: options[:class], placeholder: options[:placeholder],
                  disabled: options[:disabled], aria: options[:aria], data: options[:data])
      end

      def chip_data(chips_options)
        chips_options.each_with_object({ bs_chips: "" }) do |(key, value), data|
          data[:"bs_#{key}"] = value
        end
      end
    end
  end
end
