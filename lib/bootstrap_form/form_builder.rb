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
            args << options.except(:label, :help)
            super(name, *args) + help
          end
        end
      end
    end

    def check_box(name, *args)
      options = args.extract_options!.symbolize_keys!
      content_tag :div, class: "control-group#{(' error' if object.errors[name].any?)}"  do
        content_tag(:div, class: 'controls') do
          args << options.except(:label, :help)
          html = super(name, *args) + ' ' + options[:label]
          label(name, html, class: 'checkbox')
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
