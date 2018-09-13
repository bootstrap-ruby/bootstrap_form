module BootstrapForm
  module Helpers
    module Bootstrap

      def button(value = nil, options = {}, &block)
        setup_css_class 'btn btn-secondary', options
        super
      end

      def submit(name = nil, options = {})
        setup_css_class 'btn btn-secondary', options
        super
      end

      def primary(name = nil, options = {}, &block)
        setup_css_class 'btn btn-primary', options

        if options[:render_as_button] || block_given?
          options.except! :render_as_button
          button(name, options, &block)
        else
          submit(name, options)
        end
      end

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
        if object.errors.any?
          content_tag :ul, class: 'rails-bootstrap-forms-error-summary' do
            object.errors.full_messages.each do |error|
              concat content_tag(:li, error)
            end
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

      def static_control(*args)
        options = args.extract_options!
        name = args.first

        static_options = options.merge({
          readonly: true,
          control_class: [options[:control_class], static_class].compact.join(" ")
        })

        static_options[:value] = object.send(name) unless static_options.has_key?(:value)

        text_field_with_bootstrap(name, static_options)
      end

      def custom_control(*args, &block)
        options = args.extract_options!
        name = args.first

        form_group_builder(name, options, &block)
      end

      def prepend_and_append_input(name, options, &block)
        options = options.extract!(:prepend, :append, :input_group_class)
        input_group_class = ["input-group", options[:input_group_class]].compact.join(' ')

        input = capture(&block) || "".html_safe

        input = content_tag(:div, input_group_content(options[:prepend]), class: 'input-group-prepend') + input if options[:prepend]
        input << content_tag(:div, input_group_content(options[:append]), class: 'input-group-append') if options[:append]
        input << generate_error(name)
        input = content_tag(:div, input, class: input_group_class) unless options.empty?
        input
      end

      def input_with_error(name, &block)
        input = capture(&block)
        input << generate_error(name)
      end

      def input_group_content(content)
        return content if content.match(/btn/)
        content_tag(:span, content, class: 'input-group-text')
      end

      def static_class
        "form-control-plaintext"
      end


      private

        def setup_css_class(the_class, options = {})
          unless options.has_key? :class
            if extra_class = options.delete(:extra_class)
              the_class = "#{the_class} #{extra_class}"
            end
            options[:class] = the_class
          end
        end

    end
  end
end
