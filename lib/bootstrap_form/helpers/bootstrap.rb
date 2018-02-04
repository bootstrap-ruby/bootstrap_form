module BootstrapForm
  module Helpers
    module Bootstrap
      def submit(name = nil, options = {})
        options.reverse_merge! class: 'btn btn-secondary'
        super(name, options)
      end

      def primary(name = nil, options = {})
        options.reverse_merge! class: 'btn btn-primary'
        submit(name, options)
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

      ##
      # Add prepend and append, if any, and error if any.
      # If anything is added, the whole thing is wrapped in an input-group.
      def prepend_and_append_input(name, options, &block)
        control_error_help(name,
                           options,
                           prepend: options.delete(:prepend),
                           append: options.delete(:append),
                           &block)
      end

      ##
      # Render a block, and add its error or help.
      # Add prepend and append if provided, and wrap if they were, or if
      # an input_group_class was provided.
      def control_error_help(name, options, prepend: nil, append: nil, &block)
        error_text = generate_help(name, options.delete(:help)).to_s
        options = options.extract!(:input_group_class)
        input_group_class = ["input-group", options[:input_group_class]].compact.join(' ')

        input = capture(&block)

        input = content_tag(:div, input_group_content(prepend), class: 'input-group-prepend') + input if prepend
        input << content_tag(:div, input_group_content(append), class: 'input-group-append') if append
        input << error_text
        # FIXME: TBC The following isn't right yet. Wrap if there were errors. Maybe???
        input = content_tag(:div, input, class: input_group_class) unless options.empty? && prepend.nil? && append.nil?
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
