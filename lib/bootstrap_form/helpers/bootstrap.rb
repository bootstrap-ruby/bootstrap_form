module BootstrapForm
  module Helpers
    module Bootstrap
      def submit(name = nil, options = {})
        options.merge! class: 'btn btn-default' unless options.has_key? :class
        super(name, options)
      end

      def primary(name = nil, options = {})
        options.merge! class: 'btn btn-primary'
        submit(name, options)
      end

      def alert_message(title, options = {})
        css = options[:class] || 'alert alert-danger'

        if object.respond_to?(:errors) && object.errors.full_messages.any?
          content_tag :div, class: css do
            concat content_tag :p, title
            concat error_summary unless inline_errors || options[:error_summary] == false
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

      def errors_on(name)
        if has_error?(name)
          content_tag :div, class: "alert alert-danger" do
            object.errors.full_messages_for(name).join(", ")
          end
        end
      end

      def static_control(name, options = {}, &block)
        html = if block_given?
          capture(&block)
        else
          object.send(name)
        end

        form_group_builder(name, options) do
          content_tag(:p, html, class: static_class)
        end
      end

      def prepend_and_append_input(options, &block)
        options = options.extract!(:prepend, :append)
        input = capture(&block)

        input = content_tag(:span, options[:prepend], class: 'input-group-addon') + input if options[:prepend]
        input << content_tag(:span, options[:append], class: 'input-group-addon') if options[:append]
        input = content_tag(:div, input, class: 'input-group') if options[:prepend] || options[:append]
        input
      end

      def static_class
        "form-control-static"
      end
    end
  end
end
