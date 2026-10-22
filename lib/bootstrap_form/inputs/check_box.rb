# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module CheckBox # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern
      include Base

      included do
        def check_box_with_bootstrap(name, options={}, checked_value="1", unchecked_value="0", &block)
          options = options.symbolize_keys!

          content = tag.div(class: check_box_wrapper_class(options), **options[:wrapper].to_h.except(:class)) do
            html = check_box_without_bootstrap(name, check_box_options(name, options), checked_value, unchecked_value)
            html = switch_wrapper(html, options[:switch]) if options[:switch]
            html << check_box_content(name, options, checked_value, &block)
            html
          end
          wrapper(content, options)
        end

        bootstrap_alias :check_box
        alias_method :checkbox_with_bootstrap, :check_box_with_bootstrap if Rails::VERSION::MAJOR >= 8
        bootstrap_alias :checkbox if Rails::VERSION::MAJOR >= 8
      end

      private

      def wrapper(content, options)
        if layout == :inline && !options[:multiple]
          tag.div(class: "col") { content }
        elsif layout == :horizontal && !options[:multiple]
          form_group(layout: layout_in_effect(options[:layout]), label_col: options[:label_col]) { content }
        else
          content
        end
      end

      # Bootstrap 6 renders switches inside a `switch` wrapper, which also
      # carries theme and size classes: `switch: "theme-primary switch-lg"`,
      # or `switch: { class: "...", style: "..." }` for other attributes.
      def switch_wrapper(html, switch)
        attributes = switch.is_a?(Hash) ? switch.symbolize_keys : { class: (switch if switch.is_a?(String)) }
        tag.div(html, **attributes, class: ["switch", attributes[:class]].compact)
      end

      # Bootstrap 6 nests the label together with help text and validation
      # feedback in a `form-field-content` wrapper next to the control.
      def check_box_content(name, options, checked_value, &)
        label = (check_box_label(name, options, checked_value, &) unless options[:skip_label])
        help = generate_help(name, options[:help], id: options[:id])
        error = generate_feedback(name, options, error: options[:error_message])
        if help || error
          tag.div(safe_join([label, help, error].compact), class: "form-field-content")
        else
          label || ActiveSupport::SafeBuffer.new
        end
      end

      def check_box_options(name, options)
        check_box_options = options.except(*Components::Validation::FEEDBACK_OPTIONS, :class, :control_col,
                                           :card, :error_message, :feedback_id, :help, :hide_label, :inline, :label,
                                           :label_class, :label_col, :layout, :skip_label, :switch, :wrapper,
                                           :wrapper_class)
        check_box_options[:class] = check_box_classes(name, options)
        check_box_options[:role] = check_box_options[:switch] = "switch" if options[:switch]
        if (describedby = aria_describedby(name, options))
          check_box_options[:aria] = check_box_options[:aria].to_h.merge(describedby:)
        end
        check_box_options.merge!(required_field_options(options, name))
      end

      def check_box_label(name, options, checked_value, &)
        label_name = if options[:multiple]
                       check_box_value(name, checked_value)
                     else
                       name
                     end
        label_options = { class: check_box_label_class(options) }
        label_options[:for] = options[:id] if options[:id].present?
        label(label_name, check_box_description(name, options, &), label_options)
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
        "#{name}_#{value.to_s.gsub(/\s/, '_').gsub(/[^-[[:word:]]]/, '').downcase}"
      end

      def check_box_classes(name, options)
        classes = Array(options[:class])
        classes << "check" unless options[:switch]
        classes << "is-invalid" if error?(name)
        classes << "is-valid" if options[:valid]
        classes << "position-static" if options[:skip_label] || options[:hide_label]
        classes.flatten.compact.presence
      end

      def check_box_label_class(options)
        classes = []
        classes << options[:label_class]
        classes << "required" if options[:required]
        classes << hide_class if options[:hide_label]
        classes.flatten.compact.presence
      end

      def check_box_wrapper_class(options)
        classes = ["form-field"]
        classes << "form-field-card" if options[:card]
        classes << "d-inline-grid me-3" if layout_inline?(options[:inline])
        classes << "mb-5" unless options[:multiple] ||
                                 %i[horizontal inline].include?(layout) ||
                                 options[:wrapper_class] == false ||
                                 options.dig(:wrapper, :class) == false
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
