# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module RadioButton
      extend ActiveSupport::Concern
      include Base

      included do
        def radio_button_with_bootstrap(name, value, *args)
          options = args.extract_options!.symbolize_keys!
          wrapper_attributes = options[:wrapper] || {}
          wrapper_attributes[:class] = radio_button_wrapper_class(options)
          tag.div(**wrapper_attributes) do
            html = radio_button_without_bootstrap(name, value, radio_button_options(name, options))
            html.concat(radio_button_label(name, value, options)) unless options[:skip_label]
            html.concat(generate_error(name)) if options[:error_message]
            html
          end
        end

        bootstrap_alias :radio_button
      end

      private

      def radio_button_options(name, options)
        radio_button_options = options.except(:class, :label, :label_class, :error_message, :help,
                                              :inline, :hide_label, :skip_label, :wrapper, :wrapper_class)
        radio_button_options[:class] = radio_button_classes(name, options)
        radio_button_options
      end

      def radio_button_label(name, value, options)
        label_options = { value: value, class: radio_button_label_class(options) }
        label_options[:for] = options[:id] if options[:id].present?
        label(name, options[:label], label_options)
      end

      def radio_button_classes(name, options)
        classes = Array(options[:class]) << "form-check-input"
        classes << "is-invalid" if error?(name)
        classes << "position-static" if options[:skip_label] || options[:hide_label]
        classes.flatten.compact
      end

      def radio_button_label_class(options)
        classes = ["form-check-label"]
        classes << options[:label_class]
        classes << hide_class if options[:hide_label]
        classes.flatten.compact
      end

      def radio_button_wrapper_class(options)
        classes = ["form-check"]
        classes << "form-check-inline" if layout_inline?(options[:inline])
        classes << "disabled" if options[:disabled]
        classes << options.dig(:wrapper, :class).presence
        classes << options[:wrapper_class].presence
        classes.flatten.compact
      end
    end
  end
end
