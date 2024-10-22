# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module CheckBox
      extend ActiveSupport::Concern
      include Base

      included do
        def check_box_with_bootstrap(name, options={}, checked_value="1", unchecked_value="0", &block)
          options = options.symbolize_keys!

          content = tag.div(class: check_box_wrapper_class(options), **options[:wrapper].to_h.except(:class)) do
            html = check_box_without_bootstrap(name, check_box_options(name, options), checked_value, unchecked_value)
            html << check_box_label(name, options, checked_value, &block) unless options[:skip_label]
            html << generate_error(name) if options[:error_message]
            html
          end
          wrapper(content, options)
        end

        bootstrap_alias :check_box
      end

      private

      def wrapper(content, options)
        if layout == :inline && !options[:multiple]
          tag.div(class: "col") { content }
        elsif layout == :horizontal && !options[:multiple]
          form_group(layout: layout_in_effect(options[:layout]), label_col: options[:label_col], help: options[:help]) { content }
        else
          content
        end
      end

      def check_box_options(name, options)
        check_box_options = options.except(:class, :control_col, :error_message, :help, :hide_label,
                                           :inline, :label, :label_class, :label_col, :layout, :skip_label,
                                           :switch, :wrapper, :wrapper_class)
        check_box_options[:class] = check_box_classes(name, options)
        check_box_options.merge!(required_field_options(options, name))
      end

      def check_box_label(name, options, checked_value, &block)
        label_name = if options[:multiple]
                       check_box_value(name, checked_value)
                     else
                       name
                     end
        label_options = { class: check_box_label_class(options) }
        label_options[:for] = options[:id] if options[:id].present?
        label(label_name, check_box_description(name, options, &block), label_options)
      end

      def check_box_description(name, options, &block)
        content = block ? capture(&block) : options[:label]
        # Ugh. Next Rails after 7.1 passes `false` when there's no object.
        content || (object && object.class.human_attribute_name(name)) || name.to_s.humanize # rubocop:disable Style/SafeNavigation
      end

      def check_box_value(name, value)
        # label's `for` attribute needs to match checkbox tag's id,
        # IE sanitized value, IE
        # https://github.com/rails/rails/blob/5-0-stable/actionview/lib/action_view/helpers/tags/base.rb#L123-L125
        "#{name}_#{value.to_s.gsub(/\s/, '_').gsub(/[^-[[:word:]]]/, '').mb_chars.downcase}"
      end

      def check_box_classes(name, options)
        classes = Array(options[:class]) << "form-check-input"
        classes << "is-invalid" if error?(name)
        classes << "position-static" if options[:skip_label] || options[:hide_label]
        classes.flatten.compact
      end

      def check_box_label_class(options)
        classes = ["form-check-label"]
        classes << options[:label_class]
        classes << "required" if options[:required]
        classes << hide_class if options[:hide_label]
        classes.flatten.compact
      end

      def check_box_wrapper_class(options)
        classes = ["form-check"]
        classes << "form-check-inline" if layout_inline?(options[:inline])
        classes << "mb-3" unless options[:multiple] || %i[horizontal inline].include?(layout)
        classes << "form-switch" if options[:switch]
        classes << options.dig(:wrapper, :class).presence
        classes << options[:wrapper_class].presence
        classes.flatten.compact
      end

      def checkbox_required(options, method)
        if options[:skip_required]
          warn "`:skip_required` is deprecated, use `:required: false` instead"
          false
        elsif options.key?(:required)
          options[:required]
        else
          required_attribute?(object, method)
        end
      end
    end
  end
end
