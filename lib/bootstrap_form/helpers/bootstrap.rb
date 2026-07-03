# frozen_string_literal: true

module BootstrapForm
  module Helpers
    module Bootstrap
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
        id = options[:id]
        options = options.extract!(:prepend, :append, :input_group_class).compact

        input = capture(&) || ActiveSupport::SafeBuffer.new

        input = attach_input(options, :prepend) + input + attach_input(options, :append)
        # Bootstrap 6 places validation feedback outside the input group,
        # as a sibling within the form-field wrapper.
        options.present? &&
          input = tag.div(input, class: ["input-group", options[:input_group_class]].compact)
        input << generate_error(name, id)
        input
      end

      def input_with_error(name, id, &)
        input = capture(&)
        input << generate_error(name, id)
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
      def adorn_wrapper(field, adorn)
        adorn = { text: adorn } unless adorn.is_a?(Hash)
        content = if adorn[:icon]
                    tag.div(adorn[:icon], class: "form-adorn-icon")
                  else
                    tag.span(adorn[:text], class: "form-adorn-text")
                  end
        classes = ["form-control", "form-adorn", ("form-adorn-end" if adorn[:end]), adorn[:class]].compact
        tag.div(content + field, class: classes)
      end

      # Bootstrap 6 password strength meter, rendered after a password field.
      def strength_meter(strength)
        strength = { variant: strength } unless strength.is_a?(Hash)
        data = { bs_strength: "" }
        data[:bs_min_length] = strength[:min_length] if strength[:min_length]
        meter = if strength[:variant].to_s == "bar"
                  tag.div(class: "strength-bar", data: data)
                else
                  tag.div(safe_join(Array.new(4) { tag.div(class: "strength-segment") }), class: "strength", data: data)
                end
        strength[:text] ? meter + tag.span(class: "strength-text") : meter
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
