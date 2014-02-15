module BootstrapForm
  module BootstrapHelpers
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
      bf_options = options.extract!(:prepend, :append)
      prepend = bf_options[:prepend]
      append = bf_options[:append]
      input = capture(&block)

      input = content_tag(:span, prepend, class: 'input-group-addon') + input if prepend
      input << content_tag(:span, append, class: 'input-group-addon') if append
      input = content_tag(:div, input, class: 'input-group') if prepend || append
      input
    end

    private

    def static_class
      "form-control-static"
    end
  end
end
