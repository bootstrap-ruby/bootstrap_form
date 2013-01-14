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
        content_tag :div, class: "control-group#{(' error' if object.errors[name].any?)}"  do
          label(name, options[:label], class: 'control-label') +
          content_tag(:div, class: 'controls') do
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
    end

    def check_box(name, *args)
      options = args.extract_options!.symbolize_keys!
      args << options.except(:label, :help, :inline)

      content_tag :div, class: "control-group#{(' error' if object.errors[name].any?)}"  do
        content_tag(:div, class: 'controls') do
          html = super(name, *args) + ' ' + options[:label]

          css = 'checkbox'
          css << ' inline' if options[:inline]
          label(name, html, class: css)
        end
      end
    end

    def radio_button(name, value, *args)
      options = args.extract_options!.symbolize_keys!
      args << options.except(:label, :help, :inline)

      content_tag :div, class: "control-group#{(' error' if object.errors[name].any?)}"  do
        content_tag(:div, class: 'controls') do
          html = super(name, value, *args) + ' ' + options[:label]

          css = 'radio'
          css << ' inline' if options[:inline]
          label("#{name}_#{value}", html, class: css)
        end
      end
    end

    def control_group(label_name, label_options = {}, &block)
      content_tag :div, class: "control-group"  do
        label_options[:class] = 'control-label'
        content_tag(:label, label_name, label_options).html_safe +
        content_tag(:div, class: 'controls') do
          block.call.html_safe
        end
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
