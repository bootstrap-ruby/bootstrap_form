module BootstrapForm
  module Helpers
    module Bootstrap
      def button(value=nil, options={}, &block)
        setup_css_class "btn btn-secondary", options
        super
      end

      def submit(name=nil, options={})
        setup_css_class "btn btn-secondary", options
        super
      end

      def primary(name=nil, options={}, &block)
        setup_css_class "btn btn-primary", options

        if options[:render_as_button] || block_given?
          options.except! :render_as_button
          button(name, options, &block)
        else
          submit(name, options)
        end
      end

      def alert_message(title, options={})
        css = options[:class] || "alert alert-danger"
        return unless object.respond_to?(:errors) && object.errors.full_messages.any?

        content_tag :div, class: css do
          concat content_tag :p, title
          concat error_summary unless options[:error_summary] == false
        end
      end

      def error_summary
        return unless object.errors.any?

        content_tag :ul, class: "rails-bootstrap-forms-error-summary" do
          object.errors.full_messages.each do |error|
            concat content_tag(:li, error)
          end
        end
      end

      def errors_on(name, options={})
        return unless error?(name)

        hide_attribute_name = options[:hide_attribute_name] || false

        content_tag :div, class: "alert alert-danger" do
          if hide_attribute_name
            object.errors[name].join(", ")
          else
            object.errors.full_messages_for(name).join(", ")
          end
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

      def custom_control(*args, &block)
        options = args.extract_options!
        name = args.first

        form_group_builder(name, options, &block)
      end

      def prepend_and_append_input(name, options, &block)
        options = options.extract!(:prepend, :append, :input_group_class)

        input = capture(&block) || ActiveSupport::SafeBuffer.new

        input = attach_input(options, :prepend) + input + attach_input(options, :append)
        input += generate_error(name)
        options.present? &&
          input = content_tag(:div, input, class: ["input-group", options[:input_group_class]].compact)
        input
      end

      def input_with_error(name, &block)
        input = capture(&block)
        input << generate_error(name)
      end

      def input_group_content(content)
        return content if content =~ /btn/

        content_tag(:span, content, class: "input-group-text")
      end

      def static_class
        "form-control-plaintext"
      end

      private

      def attach_input(options, key)
        tags = [*options[key]].map do |item|
          content_tag(:div, input_group_content(item), class: "input-group-#{key}")
        end
        ActiveSupport::SafeBuffer.new(tags.join)
      end

      def setup_css_class(the_class, options={})
        return if options.key? :class

        if (extra_class = options.delete(:extra_class))
          the_class = "#{the_class} #{extra_class}"
        end
        options[:class] = the_class
      end
    end
  end
end
