# frozen_string_literal: true

module BootstrapForm
  module Components
    module Labels
      extend ActiveSupport::Concern

      private

      def generate_label(id, name, options, custom_label_col, group_layout)
        return if options.blank?

        # id is the caller's options[:id] at the only place this method is called.
        # The options argument is a small subset of the options that might have
        # been passed to generate_label's caller, and definitely doesn't include
        # :id.
        options[:for] = id if acts_like_form_tag

        options[:class] = label_classes(name, options, custom_label_col, group_layout)
        options.delete(:class) if options[:class].none?

        label(name, label_text(name, options), options.except(:text))
      end

      def label_classes(name, options, custom_label_col, group_layout)
        classes = [options[:class] || label_layout_classes(custom_label_col, group_layout)]
        add_class = options.delete(:add_class)
        classes.prepend(add_class) if add_class
        classes << "required" if required_field_options(options, name)[:required]
        options.delete(:required)
        classes << "text-danger" if label_errors && error?(name)
        classes.flatten.compact
      end

      def label_layout_classes(custom_label_col, group_layout)
        if layout_horizontal?(group_layout)
          ["col-form-label", (custom_label_col || label_col)]
        elsif layout_inline?(group_layout)
          %w[form-label me-sm-2]
        else
          "form-label"
        end
      end

      def label_text(name, options)
        label = options[:text] || object&.class&.try(:human_attribute_name, name)&.html_safe # rubocop:disable Rails/OutputSafety
        if label_errors && error?(name)
          (" ".html_safe + get_error_messages(name)).prepend(label)
        else
          label
        end
      end
    end
  end
end
