# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module OtpField
      extend ActiveSupport::Concern
      include Base

      included do
        # Bootstrap 6 OTP input: a single real text input rendered as digit
        # slots. The number of slots comes from the input's `maxlength`
        # (default 6). Configuration is passed in the `:otp` option and
        # rendered as `data-bs-*` attributes on the `.otp` container, e.g.
        # `otp: { type: :numeric, groups: [3, 3] }`. Arrays are converted to
        # JSON. Use `otp: { class: "..." }` for container classes such as
        # `otp-connected`, `otp-sm` or `otp-lg`.
        def otp_field(name, options={})
          options = options.symbolize_keys
          otp_options = options.delete(:otp).to_h.symbolize_keys
          options[:maxlength] ||= 6
          options[:size] = nil unless options.key?(:size) # suppress Rails' size-from-maxlength default
          options[:autocomplete] ||= "one-time-code"
          options = options.reverse_merge(control_class: "otp-input")
          form_group_builder(name, options) do
            otp_container(name, otp_options, options)
          end
        end
      end

      private

      def otp_container(name, otp_options, options)
        classes = ["otp", otp_options.delete(:class)].compact
        classes << "is-invalid" if error?(name)
        container = tag.div(class: classes, data: otp_data(otp_options)) do
          text_field_without_bootstrap(name, options)
        end
        safe_join([container, generate_error(name, options[:id])].compact)
      end

      def otp_data(otp_options)
        otp_options.each_with_object({ bs_otp: "" }) do |(key, value), data|
          data[:"bs_#{key}"] = value.is_a?(Array) ? value.to_json : value
        end
      end
    end
  end
end
