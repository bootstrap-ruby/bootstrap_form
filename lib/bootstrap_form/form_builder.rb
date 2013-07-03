module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    FORM_HELPERS = %w{text_field password_field text_area file_field
                     number_field email_field telephone_field phone_field url_field
                     select collection_select date_select time_select datetime_select}

    delegate :content_tag, to: :@template
    delegate :capture, to: :@template

    def initialize(object_name, object, template, options, proc=nil)
      help = options.fetch(:help, nil)
      @help_class = help.eql?(:block) ? 'help-block' : 'help-inline'

      super
    end

    FORM_HELPERS.each do |method_name|
      define_method(method_name) do |name, *args|
        options = args.extract_options!.symbolize_keys!

        label = options.delete(:label)
        help  = options.delete(:help)

        control_group(name, label: { text: label }, help: help) do

          args << options.except(:prepend, :append)
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

          element
        end
      end
    end

    def check_box(name, options = {}, checked_value = "1", unchecked_value = "0")
      options = options.symbolize_keys!

      html = super(name, options.except(:label, :help, :inline), checked_value, unchecked_value) 
      html += ' ' + (options[:label] || name.to_s.humanize)

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
      errors_has_name = object.respond_to?(:errors) && !(name.nil? || object.errors[name].empty?)

      options[:class] ||= 'control-group'
      options[:class] << ' error' if errors_has_name

      label = options.delete(:label)
      _help = options.delete(:help)

      content_tag(:div, options) do
        html = ''

        if label && label[:text] != :none
          label[:class] ||= 'control-label'
          label[:for] ||= '' if name.nil?

          html << label(name, label[:text], label.except(:text))
        end

        html << content_tag(:div, class: 'controls') do
          controls = capture(&block)

          help = errors_has_name ? object.errors[name].join(', ') : _help
          controls << content_tag(:span, help, class: @help_class) if help

          controls.html_safe
        end

        html.html_safe
      end
    end

    def actions(&block)
      content_tag :div, class: "form-actions" do
        capture(&block)
      end
    end

    def primary(name, options = {})
      options.merge! class: 'btn btn-primary'
      submit name, options
    end

    def secondary(name, options = {})
      options.merge! class: 'btn'
      submit name, options
    end

    def alert_message(title, *args)
      options = args.extract_options!
      css = options[:class] || "alert alert-error"

      if object.respond_to?(:errors) && object.errors.full_messages.any?
        content_tag :div, class: css do
          title
        end
      end
    end
  end
end
