module FormBootstrap
  class Builder < ActionView::Helpers::FormBuilder
    delegate :content_tag, to: :@template

    def initialize(object_name, object, template, options, proc)
      super
      @help_css = (options[:help].try(:to_sym) == :block) ? 'help-block' : 'help-inline'
    end

    %w{text_field text_area password_field collection_select file_field date_select}.each do |method_name|
      define_method(method_name) do |name, *args|
        options = args.extract_options!.stringify_keys
        content_tag :div, class: "clearfix#{(' error' if object.errors[name].any?)}"  do
          label(name, options['label']) +
          content_tag(:div, class: 'input') do
            help = object.errors[name].any? ? object.errors[name].join(', ') : options['help']
            help = content_tag(:span, class: @help_css) { help } if help
            super(name, *args, options.except('label', 'help')) + help
          end
        end
      end
    end

    def actions(name)
      content_tag :div, class: "actions" do
        submit name, class: 'btn primary'
      end
    end

    def alert_message(title, *args)
      options = args.extract_options!
      css = options[:class] || "alert-message error"

      if object.errors.full_messages.any?
        content_tag :div, class: css do
          title
        end
      end
    end
  end
end
