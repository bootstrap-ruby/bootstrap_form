module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :style, :left_class, :right_class, :has_error

    BOOTSTRAP_OPTIONS = [:label, :hide_label, :help, :prepend, :append]
    FORM_HELPERS = %w{text_field password_field text_area file_field
                     number_field email_field telephone_field phone_field url_field
                     select collection_select date_select time_select datetime_select}

    delegate :content_tag, to: :@template
    delegate :capture, to: :@template

    def initialize(object_name, object, template, options, proc=nil)
      @style = options[:style]
      @left_class = options[:left] || default_left_class
      @right_class = options[:right] || default_right_class
      super
    end

    FORM_HELPERS.each do |method_name|
      define_method(method_name) do |name, *args|
        normalize_args!(method_name, args)
        options = args.extract_options!.symbolize_keys!

        label = options.delete(:label)
        label_class = hide_class if options.delete(:hide_label)
        help = options.delete(:help)

        form_group(name, label: { text: label, class: label_class }, help: help) do
          options[:class] = "form-control #{options[:class]}".rstrip
          args << options.except(:prepend, :append)
          input = super(name, *args)
          prepend_and_append_input(input, options[:prepend], options[:append])
        end
      end
    end

    def hidden_field(name, options = {})
      options = options.symbolize_keys!
      html = super(name, options)
    end

    def check_box(name, options = {}, checked_value = '1', unchecked_value = '0')
      options = options.symbolize_keys!

      html = super(name, options.except(:label, :help, :inline), checked_value, unchecked_value)
      html << ' ' + (options[:label] || object.class.human_attribute_name(name) || name.to_s.humanize)

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
      css << '-inline' if options[:inline]
      label("#{name}_#{value}", html, class: css)
    end

    def form_group(name = nil, options = {}, &block)
      options[:class] = 'form-group'
      options[:class] << ' has-error' if has_error?(name)

      html = capture(&block)
      html << generate_help(name, options[:help])
      html = content_tag(:div, html, class: right_class) if horizontal?

      content_tag(:div, options.except(:label, :help)) do
        "#{generate_label(name, options[:label])}#{html}".html_safe
      end
    end

    def submit(name = nil, options = {})
      options.merge! class: 'btn btn-default' unless options.has_key? :class
      super(name, options)
    end

    def primary(name = nil, options = {})
      options.merge! class: 'btn btn-primary'
      submit(name, options)
    end

    def alert_message(title, *args)
      options = args.extract_options!
      css = options[:class] || 'alert alert-danger'

      if object.respond_to?(:errors) && object.errors.full_messages.any?
        content_tag :div, title, class: css
      end
    end

    def fields_for(record_name, record_object = nil, fields_options = {}, &block)
      fields_options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?
      fields_options[:style] ||= options[:style]
      fields_options[:left] = (fields_options.include?(:left)) ? fields_options[:left] + " control-label" : options[:left]
      fields_options[:right] ||= options[:right]
      super(record_name, record_object, fields_options, &block)
    end

    def static_control(name, options = {}, &block)
      label = options.delete(:label)
      label_class = hide_class if options.delete(:hide_label)
      help = options.delete(:help)

      html = if block_given?
        capture(&block)
      else
        object.send(name)
      end

      form_group(name, label: { text: label, class: label_class }, help: help) do
        content_tag(:p, html, class: static_class)
      end
    end

    private

    def normalize_args!(method_name, args)
      return unless method_name =~ /select/

      if method_name == "select"
        args << {} while args.length < 3
      elsif method_name == "collection_select"
        args << {} while args.length < 5
      elsif method_name =~ /_select/
        args << {} while args.length < 2
      end

      html_options = args.extract_options!.symbolize_keys!
      helper_options = args.extract_options!.symbolize_keys!

      # move the bootstrap-specific arguments from the helper_options hash
      # the html_options hash
      html_options.merge! helper_options.extract!(*BOOTSTRAP_OPTIONS)
      args.concat [helper_options, html_options]
    end

    def horizontal?
      style == :horizontal
    end

    def default_left_class
      "col-sm-2"
    end

    def default_right_class
      "col-sm-10"
    end

    def default_label_class
      "control-label"
    end

    def hide_class
      "sr-only" # still accessible for screen readers
    end

    def static_class
      "form-control-static"
    end

    def has_error?(name)
      object.respond_to?(:errors) && !(name.nil? || object.errors[name].empty?)
    end

    def prepend_and_append_input(input, prepend, append)
      input = content_tag(:span, prepend, class: 'input-group-addon') + input if prepend
      input << content_tag(:span, append, class: 'input-group-addon') if append
      input = content_tag(:div, input, class: 'input-group') if prepend || append
      input
    end

    def generate_label(name, options)
      if options
        options[:class] = "#{options[:class]} #{default_label_class}".lstrip
        options[:class] << " #{left_class}" if horizontal?
        label(name, options[:text], options.except(:text))
      elsif horizontal?
        # no label. create an empty one to keep proper form alignment.
        content_tag(:label, "", class: "#{default_label_class} #{left_class}")
      end
    end

    def generate_help(name, help_text)
      help_text = object.errors[name].join(', ') if has_error?(name)
      content_tag(:span, help_text, class: 'help-block') if help_text
    end
  end
end
