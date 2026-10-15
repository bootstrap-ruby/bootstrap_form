# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module DatepickerField
      extend ActiveSupport::Concern
      include Base

      included do
        # Bootstrap 6 datepickers are text fields activated by
        # `data-bs-toggle="datepicker"`. There is no Rails helper for them, so
        # this helper delegates to `text_field`. Datepicker configuration is
        # passed in the `:datepicker` option and rendered as `data-bs-*`
        # attributes, e.g. `datepicker: { selection_mode: "multiple-ranged" }`
        # becomes `data-bs-selection-mode="multiple-ranged"`.
        #
        # `inline: true` renders an always-visible calendar in a `div` with a
        # hidden input that Bootstrap keeps in sync for form submission.
        # `button: "Select date"` (or `button: { text:, icon: }`) renders a
        # button trigger instead of a text field; Bootstrap updates the
        # button's text but submits nothing.
        def datepicker_field(name, options={})
          options = options.symbolize_keys
          datepicker_options = options.delete(:datepicker).to_h.symbolize_keys
          return inline_datepicker(name, datepicker_options, options) if options.delete(:inline)
          return datepicker_button(name, options.delete(:button), datepicker_options, options) if options[:button]

          options[:autocomplete] = "off" unless options.key?(:autocomplete)
          options[:data] = datepicker_data(datepicker_options).merge(options[:data].to_h)
          text_field_with_bootstrap(name, options)
        end
      end

      private

      def datepicker_data(datepicker_options)
        datepicker_options.to_h.each_with_object({ bs_toggle: "datepicker" }) do |(key, value), data|
          value = value.iso8601 if value.respond_to?(:iso8601)
          value = value.to_json if value.is_a?(Array)
          data[:"bs_#{key}"] = value
        end
      end

      def inline_datepicker(name, datepicker_options, options)
        value = options.key?(:value) ? options[:value] : object&.try(name)
        datepicker_options[:selected_dates] ||= Array(value) if value.present?
        data = datepicker_data(datepicker_options.merge(inline: true)).merge(options[:data].to_h)
        options = options.reverse_merge(control_class: nil)
        form_group_builder(name, options) do
          tag.div(class: options[:class].presence, data:) do
            hidden_options = { value: value.respond_to?(:iso8601) ? value.iso8601 : value }
            hidden_options[:id] = options[:id] if options[:id]
            hidden_field(name, hidden_options)
          end
        end
      end

      def datepicker_button(name, button, datepicker_options, options)
        button = { text: button } unless button.is_a?(Hash)
        options[:id] ||= field_id(name, namespace: nil)
        options = options.reverse_merge(control_class: "btn-outline theme-secondary")
        data = datepicker_data(datepicker_options).merge(options[:data].to_h)
        form_group_builder(name, options) do
          tag.button(type: "button", id: namespaced_id(options[:id]), class: options[:class], data:,
                     disabled: options[:disabled]) do
            text = button[:text].is_a?(String) ? button[:text] : "Select date"
            safe_join([button[:icon], tag.span(text, data: { bs_datepicker_display: "" })].compact)
          end
        end
      end
    end
  end
end
