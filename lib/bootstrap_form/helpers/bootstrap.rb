# frozen_string_literal: true

module BootstrapForm
  module Helpers
    module Bootstrap # rubocop:disable Metrics/ModuleLength
      include ActionView::Helpers::OutputSafetyHelper

      def alert_message(title, options={})
        css = options[:class] || "alert theme-danger"
        return unless object.respond_to?(:errors) && object.errors.full_messages.any?

        tag.div class: css, **options.except(:class, :error_summary) do
          if options[:error_summary] == false
            title
          else
            tag.p(title) + error_summary
          end
        end
      end

      def error_summary
        return unless object.errors.any?

        tag.ul(class: "rails-bootstrap-forms-error-summary") do
          object.errors.full_messages.reduce(ActiveSupport::SafeBuffer.new) do |acc, error|
            acc << tag.li(error)
          end
        end
      end

      def errors_on(name, options={})
        return unless error?(name)

        hide_attribute_name = options[:hide_attribute_name] || false
        custom_class = options[:custom_class] || false

        tag.div(
          class: custom_class || "invalid-feedback",
          id: aria_feedback_id(id: options[:id], name:)
        ) do
          errors = if hide_attribute_name
                     object.errors[name]
                   else
                     object.errors.full_messages_for(name)
                   end
          safe_join(errors, ", ")
        end
      end

      def static_control(*args)
        options = args.extract_options!
        name = args.first

        static_options = options.merge(
          readonly: true,
          control_class: [options[:control_class], static_class].compact
        )

        static_options[:value] = object.send(name) unless static_options.key?(:value)

        text_field_with_bootstrap(name, static_options)
      end

      def custom_control(*args, &)
        options = args.extract_options!
        name = args.first

        form_group_builder(name, options, &)
      end

      def prepend_and_append_input(name, options, &)
        feedback = generate_feedback(name, options)
        floating = options[:floating]
        options[:placeholder] ||= name if floating
        floating_label = options[:floating_label]
        valid = options[:valid]
        options = options.extract!(:prepend, :append, :input_group_class).compact

        input = capture(&) || ActiveSupport::SafeBuffer.new
        input = floating_wrapper(name, floating_label, input, valid:) if floating

        input = attach_input(options, :prepend) + input + attach_input(options, :append)
        # Bootstrap 6 places validation feedback outside the input group,
        # as a sibling within the form-field wrapper.
        options.present? &&
          input = tag.div(input, class: ["input-group", options[:input_group_class]].compact)
        input << feedback if feedback
        input
      end

      # Bootstrap 6 floating labels: the label and control sit alone in a
      # `form-floating` wrapper (inside the input group, if any), while help
      # text and validation feedback stay outside it in the form field.
      def floating_wrapper(name, label, input, valid:)
        classes = ["form-floating", ("is-invalid" if error?(name)), ("is-valid" if valid)].compact
        tag.div(label + input, class: classes)
      end

      def input_with_error(name, options, &)
        input = capture(&)
        feedback = generate_feedback(name, options)
        feedback ? input << feedback : input
      end

      def input_group_content(content)
        return content if content.include?("btn")

        tag.span(content, class: "input-group-text")
      end

      def static_class
        "form-control-plaintext"
      end

      # Bootstrap 6 form-adorn: decorate an input with an icon or text inside
      # a `form-control form-adorn` wrapper; the input itself is a form-ghost.
      # As in the docs the wrapper is a label, so clicking the adornment
      # focuses the input, and the adornment is hidden from assistive
      # technology because the field already has a label.
      def adorn_wrapper(field, adorn, name:, options:)
        adorn = { text: adorn } unless adorn.is_a?(Hash)
        content = if adorn[:icon]
                    tag.div(adorn[:icon], class: "form-adorn-icon", aria: { hidden: true })
                  else
                    tag.span(adorn[:text], class: "form-adorn-text", aria: { hidden: true })
                  end
        classes = ["form-control", "form-adorn", ("form-adorn-end" if adorn[:end]), adorn[:class],
                   ("is-invalid" if error?(name)), ("is-valid" if options[:valid])].compact
        tag.label(content + field, class: classes)
      end

      STRENGTH_LEVELS = %w[weak fair good strong].freeze

      # Bootstrap 6 password strength meter, rendered after a password field.
      # With `level:` (weak, fair, good or strong) the meter is static,
      # server-rendered mark-up. Bootstrap's JavaScript would still bind the
      # neighbouring password field and overwrite the level, so a static
      # meter points `data-bs-input` at a selector that matches nothing.
      def strength_meter(strength)
        strength = { variant: strength } unless strength.is_a?(Hash)
        level = strength[:level]&.to_s
        data = { bs_strength: level || "" }
        data[:bs_input] = ":not(*)" if level
        data[:bs_min_length] = strength[:min_length] if strength[:min_length]
        meter = if strength[:variant].to_s == "bar"
                  tag.div(class: "strength-bar", data: data)
                else
                  tag.div(strength_segments(level), class: "strength", data: data)
                end
        meter + strength_text(strength[:text])
      end

      def strength_segments(level)
        active = level ? STRENGTH_LEVELS.index(level).to_i + 1 : 0
        safe_join(Array.new(4) { |i| tag.div(class: ["strength-segment", ("active" if i < active)].compact) })
      end

      def strength_text(text)
        return ActiveSupport::SafeBuffer.new unless text

        tag.span((text if text.is_a?(String)), class: "strength-text")
      end

      private

      def attach_input(options, key)
        tags = [*options[key]].map do |item|
          input_group_content(item)
        end
        safe_join(tags)
      end
    end
  end
end
