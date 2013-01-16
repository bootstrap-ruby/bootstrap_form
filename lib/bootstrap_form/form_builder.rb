module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    FORM_HELPERS = %w{text_field password_field text_area file_field
                     number_field email_field telephone_field phone_field url_field
                     select collection_select date_select time_select datetime_select}

    delegate :content_tag, to: :@template

    def initialize(object_name, object, template, options, proc)
      super
      @help_tag, @help_css = if options.fetch(:help, '').to_sym == :block
        [:p, 'help-block']
      else
        [:span, 'help-inline']
      end
    end

    FORM_HELPERS.each do |method_name|
      define_method(method_name) do |name, *args|
        options = args.extract_options!.symbolize_keys!

        control_group(name, label: { text: options[:label] }) do
          help = object.errors[name].any? ? object.errors[name].join(', ') : options[:help]
          help = content_tag(@help_tag, class: @help_css) { help } if help

          args << options.except(:label, :help, :prepend)
          element = super(name, *args) + help

          if prepend = options.delete(:prepend)
            element = content_tag(:div, class: 'input-prepend') do
              content_tag(:span, prepend, class: 'add-on') + element
            end
          end

          element
        end
      end
    end

    def check_box(name, *args)
      options = args.extract_options!.symbolize_keys!
      args << options.except(:label, :help, :inline)

      html = super(name, *args) + ' ' + options[:label]

      css = 'checkbox'
      css << ' inline' if options[:inline]
      label(name, html, class: css)
    end

    def radio_button(name, value, *args)
      options = args.extract_options!.symbolize_keys!
      args << options.except(:label, :help, :inline)

      html = super(name, value, *args) + ' ' + options[:label]

      css = 'radio'
      css << ' inline' if options[:inline]
      label("#{name}_#{value}", html, class: css)
    end

    def control_group(name = nil, options = {}, &block)
      options[:class] ||= 'control-group'
      options[:class] << ' error' if name && object.errors[name].any?

      content_tag(:div, options.except(:label)) do
        html = ''

        if attrs = options.delete(:label)
          attrs[:class] ||= 'control-label'
          attrs[:for] ||= '' if name.nil?

          html << label(name, attrs[:text], attrs.except(:text))
        end

        html << content_tag(:div, class: 'controls') do
          block.call.html_safe
        end

        html.html_safe
      end
    end

    def actions(&block)
      content_tag :div, class: "form-actions" do
        block.call
      end
    end

    def primary(name, options = {})
      options.merge! class: 'btn btn-primary'

      submit name, options
    end

    def alert_message(title, *args)
      options = args.extract_options!
      css = options[:class] || "alert alert-error"

      if object.errors.full_messages.any?
        content_tag :div, class: css do
          title
        end
      end
    end
  end
end
