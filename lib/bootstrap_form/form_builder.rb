module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    FORM_HELPERS = %w{text_field password_field text_area file_field
                     number_field email_field telephone_field phone_field url_field
                     select collection_select date_select time_select datetime_select}

    delegate :content_tag, to: :@template
    delegate :capture, to: :@template

    def initialize(object_name, object, template, options, proc=nil)
      super
    end

    FORM_HELPERS.each do |method_name|
      define_method(method_name) do |name, *args|
        options = args.extract_options!.symbolize_keys!

        label = options.delete(:label)
        label_class = options.delete(:label_class)
        help  = options.delete(:help)

        form_group(name, label: { text: label, class: label_class }, help: help) do
          options[:class] = "form-control #{options[:class]}".rstrip
          args << options.except(:prepend, :append, :wrap_control)
          element = super(name, *args)

          if prepend = options.delete(:prepend)
            element = content_tag(:div, class: 'input-prepend') do
              content_tag(:span, prepend, class: 'add-on') + element
            end
          end

          if append = options.delete(:append)
            element = content_tag(:div, class: 'input-append') do
              element + content_tag(:span, append, class: 'add-on')
            end
          end

          if wrap_control = options.delete(:wrap_control)
            element = content_tag(:div, class: wrap_control) do
              element
            end
          end

          element
        end
      end
    end

    def check_box(name, options = {}, checked_value = '1', unchecked_value = '0')
      options = options.symbolize_keys!

      html = super(name, options.except(:label, :help, :inline), checked_value, unchecked_value)
      html += ' ' + (options[:label] || name.to_s.humanize)

      if options[:inline]
        label(name, html, class: "checkbox-inline")
      else
        content_tag(:div, class: "checkbox") do
          label(name, html)
        end
      end
    end

    def radio_button(name, value, *args)
      options = args.extract_options!.symbolize_keys!
      args << options.except(:label, :help, :inline)

      html = super(name, value, *args) + ' ' + options[:label]

      css = 'radio'
      css << ' inline' if options[:inline]
      label("#{name}_#{value}", html, class: css)
    end

    def form_group(name = nil, options = {}, &block)
      errors_has_name = object.respond_to?(:errors) && !(name.nil? || object.errors[name].empty?)

      options[:class] ||= 'form-group'
      options[:class] << ' error' if errors_has_name

      label_options = options.delete(:label)
      if label_options && @options[:style] == :horizontal
        label_options[:class] = "#{label_options[:class]} control-label".lstrip
      end
      label_html = label_options && label(name, label_options[:text], label_options.except(:text)) || ""

      html = capture(&block)
      if wrap_content = options.delete(:wrap_content)
        html = content_tag(:div, class: wrap_content) do
          html
        end
      end

      help_text = options.delete(:help)
      help_text = object.errors[name].join(', ') if errors_has_name
      help_html = help_text && content_tag(:span, help_text, class: 'help-block') || ""

      content_tag(:div, options) do
        (label_html + html + help_html).html_safe
      end
    end

    def submit(name, options = {})
      options.merge! class: 'btn btn-default' unless options.has_key? :class
      super name, options
    end

    def alert_message(title, *args)
      options = args.extract_options!
      css = options[:class] || 'alert alert-error'

      if object.respond_to?(:errors) && object.errors.full_messages.any?
        content_tag :div, class: css do
          title
        end
      end
    end
  end
end
