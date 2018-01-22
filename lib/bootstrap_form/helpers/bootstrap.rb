module BootstrapForm
  module Helpers
    module Bootstrap

      def alert_message(title, options = {})
        css = options[:class] || 'alert alert-danger'

        if object.respond_to?(:errors) && object.errors.full_messages.any?
          content_tag :div, class: css do
            concat content_tag :p, title
            concat error_summary unless options[:error_summary] == false
          end
        end
      end

      def error_summary
        content_tag :ul, class: 'rails-bootstrap-forms-error-summary' do
          object.errors.full_messages.each do |error|
            concat content_tag(:li, error)
          end
        end
      end

      def errors_on(name, options = {})
        if has_error?(name)
          hide_attribute_name = options[:hide_attribute_name] || false

          content_tag :div, class: "alert alert-danger" do
            if hide_attribute_name
              object.errors[name].join(", ")
            else
              object.errors.full_messages_for(name).join(", ")
            end
          end
        end
      end

      def static_control(*args, &block)
        options = args.extract_options!
        name = args.first

        html = if block_given?
          capture(&block)
        else
          object.send(name)
        end

        form_group_builder(name, options) do
          content_tag(:p, html, class: static_class)
        end
      end

      def custom_control(*args, &block)
        options = args.extract_options!
        name = args.first

        form_group_builder(name, options, &block)
      end

      def prepend_and_append_input(options, &block)
        options = options.extract!(:prepend, :append, :input_group_class)
        input_group_class = ["input-group", options[:input_group_class]].compact.join(' ')

        input = capture(&block)

        input = content_tag(:div, input_group_content(options[:prepend]), class: 'input-group-prepend') + input if options[:prepend]
        input << content_tag(:div, input_group_content(options[:append]), class: 'input-group-append') if options[:append]
        input = content_tag(:div, input, class: input_group_class) unless options.empty?
        input
      end

      def input_group_content(content)
        return content if content.match(/btn/)
        content_tag(:span, content, class: 'input-group-text')
      end

      def static_class
        "form-control-static"
      end
    end
  end
end
