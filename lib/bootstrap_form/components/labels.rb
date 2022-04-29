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
        classes = ["form-label", options[:class], label_layout_classes(custom_label_col, group_layout)]

        case options.delete(:required)
        when true
          classes << "required"
        when nil, :default
          classes << "required" if required_attribute?(object, name)
        end

        classes << "text-danger" if label_errors && error?(name)
        classes.flatten.compact
      end

      def label_layout_classes(custom_label_col, group_layout)
        if layout_horizontal?(group_layout)
          ["col-form-label", (custom_label_col || label_col)]
        elsif layout_inline?(group_layout)
          ["mr-sm-2"]
        end
      end

      def label_text(name, options)
        if label_errors && error?(name)
          (options[:text] || object.class.human_attribute_name(name)).to_s.concat(" #{get_error_messages(name)}")
        else
          options[:text] || object&.class.try(:human_attribute_name, name)
        end
      end
    end
  end
end
