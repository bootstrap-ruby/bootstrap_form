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
        def datepicker_field(name, options={})
          options = options.symbolize_keys
          datepicker_options = options.delete(:datepicker).to_h
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
    end
  end
end
