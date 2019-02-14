# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module CheckBox
      extend ActiveSupport::Concern
      include Base

      # rubocop:disable Metrics/BlockLength
      included do
        def check_box_with_bootstrap(name, options={}, checked_value="1", unchecked_value="0", &block)
          options = options.symbolize_keys!
          check_box_options = options.except(:label, :label_class, :error_message, :help,
                                             :inline, :custom, :hide_label, :skip_label, :wrapper_class)
          check_box_classes = [check_box_options[:class]]
          check_box_classes << "position-static" if options[:skip_label] || options[:hide_label]
          check_box_classes << "is-invalid" if has_error?(name)

          label_classes = [options[:label_class]]
          label_classes << hide_class if options[:hide_label]

          if options[:custom]
            check_box_options[:class] = (["custom-control-input"] + check_box_classes).compact.join(" ")
            wrapper_class = ["custom-control", "custom-checkbox"]
            wrapper_class.append("custom-control-inline") if layout_inline?(options[:inline])
            label_class = label_classes.prepend("custom-control-label").compact.join(" ")
          else
            check_box_options[:class] = (["form-check-input"] + check_box_classes).compact.join(" ")
            wrapper_class = ["form-check"]
            wrapper_class.append("form-check-inline") if layout_inline?(options[:inline])
            label_class = label_classes.prepend("form-check-label").compact.join(" ")
          end

          checkbox_html = check_box_without_bootstrap(name, check_box_options, checked_value, unchecked_value)
          label_content = block_given? ? capture(&block) : options[:label]
          label_description = label_content || (object && object.class.human_attribute_name(name)) || name.to_s.humanize

          label_name = name
          # label's `for` attribute needs to match checkbox tag's id,
          # IE sanitized value, IE
          # https://github.com/rails/rails/blob/5-0-stable/actionview/lib/action_view/helpers/tags/base.rb#L123-L125
          if options[:multiple]
            label_name =
              "#{name}_#{checked_value.to_s.gsub(/\s/, '_').gsub(/[^-[[:word:]]]/, '').mb_chars.downcase}"
          end

          label_options = { class: label_class }
          label_options[:for] = options[:id] if options[:id].present?

          wrapper_class.append(options[:wrapper_class]) if options[:wrapper_class]

          content_tag(:div, class: wrapper_class.compact.join(" ")) do
            html = if options[:skip_label]
                     checkbox_html
                   else
                     checkbox_html.concat(label(label_name, label_description, label_options))
                   end
            html.concat(generate_error(name)) if options[:error_message]
            html
          end
        end

        bootstrap_alias :check_box
      end
      # rubocop:enable Metrics/BlockLength
    end
  end
end
