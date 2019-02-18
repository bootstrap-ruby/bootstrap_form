# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module RadioButton
      extend ActiveSupport::Concern
      include Base

      # rubocop:disable Metrics/BlockLength
      included do
        def radio_button_with_bootstrap(name, value, *args)
          options = args.extract_options!.symbolize_keys!
          radio_options = options.except(:label, :label_class, :error_message, :help,
                                         :inline, :custom, :hide_label, :skip_label,
                                         :wrapper_class)
          radio_classes = [options[:class]]
          radio_classes << "position-static" if options[:skip_label] || options[:hide_label]
          radio_classes << "is-invalid" if has_error?(name)

          label_classes = [options[:label_class]]
          label_classes << hide_class if options[:hide_label]

          if options[:custom]
            radio_options[:class] = radio_classes.prepend("custom-control-input").compact.join(" ")
            wrapper_class = ["custom-control", "custom-radio"]
            wrapper_class.append("custom-control-inline") if layout_inline?(options[:inline])
            label_class = label_classes.prepend("custom-control-label").compact.join(" ")
          else
            radio_options[:class] = radio_classes.prepend("form-check-input").compact.join(" ")
            wrapper_class = ["form-check"]
            wrapper_class.append("form-check-inline") if layout_inline?(options[:inline])
            wrapper_class.append("disabled") if options[:disabled]
            label_class = label_classes.prepend("form-check-label").compact.join(" ")
          end
          radio_html = radio_button_without_bootstrap(name, value, radio_options)

          label_options = { value: value, class: label_class }
          label_options[:for] = options[:id] if options[:id].present?

          wrapper_class.append(options[:wrapper_class]) if options[:wrapper_class]

          content_tag(:div, class: wrapper_class.compact.join(" ")) do
            html = if options[:skip_label]
                     radio_html
                   else
                     radio_html.concat(label(name, options[:label], label_options))
                   end
            html.concat(generate_error(name)) if options[:error_message]
            html
          end
        end

        bootstrap_alias :radio_button
      end
      # rubocop:enable Metrics/BlockLength
    end
  end
end
