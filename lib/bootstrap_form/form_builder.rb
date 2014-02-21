module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    include BootstrapForm::BootstrapHelpers

    attr_reader :style, :left_class, :right_class, :has_error, :inline_errors

    FIELD_HELPERS = %w{color_field date_field datetime_field datetime_local_field
      email_field month_field number_field password_field phone_field
      range_field search_field telephone_field text_area text_field time_field
      url_field week_field}

    DATE_SELECT_HELPERS = %w{date_select time_select datetime_select}

    delegate :content_tag, :capture, :concat, to: :@template

    def initialize(object_name, object, template, options, proc=nil)
      @style = options[:style]
      @left_class = options[:left] || default_left_class
      @right_class = options[:right] || default_right_class
      @inline_errors = options[:inline_errors] != false
      super
    end

    FIELD_HELPERS.each do |method_name|
      define_method(method_name) do |name, options = {}|
        form_group_builder(name, options) do
          prepend_and_append_input(options) do
            super(name, options)
          end
        end
      end
    end

    DATE_SELECT_HELPERS.each do |method_name|
      define_method(method_name) do |name, options = {}, html_options = {}|
        form_group_builder(name, options, html_options) do
          content_tag(:div, super(name, options, html_options), class: control_specific_class(method_name))
        end
      end
    end

    def file_field(name, options = {})
      form_group_builder(name, options.reverse_merge(control_class: nil)) do
        super(name, options)
      end
    end

    def select(method, choices, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        super(method, choices, options, html_options)
      end
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        super(method, collection, value_method, text_method, options, html_options)
      end
    end

    def check_box(name, options = {}, checked_value = "1", unchecked_value = "0", &block)
      options = options.symbolize_keys!

      html = super(name, options.except(:label, :help, :inline), checked_value, unchecked_value)
      label_content = block_given? ? capture(&block) : options[:label]
      html.concat(" ").concat(label_content || object.class.human_attribute_name(name) || name.to_s.humanize)

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

      html = super(name, value, *args) + " " + options[:label]

      css = "radio"
      css << "-inline" if options[:inline]
      label("#{name}_#{value}", html, class: css)
    end

    def check_boxes_collection(*args)
      inputs_collection(*args) do |name, value, options|
        options[:multiple] = true
        check_box(name, options, value, nil)
      end
    end

    def radio_buttons_collection(*args)
      inputs_collection(*args) do |name, value, options|
        radio_button(name, value, options)
      end
    end

    def form_group(name = nil, options = {}, &block)
      options[:class] = "form-group"
      options[:class] << " has-error" if has_error?(name)

      html = capture(&block)
      html << generate_help(name, options[:help])
      html = content_tag(:div, html, class: (options[:right] || right_class)) if horizontal?

      content_tag(:div, options.except(:label, :help, :left, :right)) do
        if options[:label]
          label_classes = [options[:label][:class], label_class]
          label_classes << (options[:left] || left_class) if horizontal?
          options[:label][:class] = label_classes.compact.join(" ")
        end
        "#{generate_label(name, options[:label])}#{html}".html_safe
      end
    end

    def fields_for(record_name, record_object = nil, fields_options = {}, &block)
      fields_options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?
      fields_options[:style] ||= options[:style]
      fields_options[:left] = (fields_options.include?(:left)) ? fields_options[:left] + " #{label_class}" : options[:left]
      fields_options[:right] ||= options[:right]
      super(record_name, record_object, fields_options, &block)
    end

    private

    def horizontal?
      style == :horizontal
    end

    def default_left_class
      "col-sm-2"
    end

    def default_right_class
      "col-sm-10"
    end

    def hide_class
      "sr-only" # still accessible for screen readers
    end

    def control_class
      "form-control"
    end

    def label_class
      "control-label"
    end

    def control_specific_class(method)
      "rails-bootstrap-forms-#{method.gsub(/_/, "-")}"
    end

    def has_error?(name)
      object.respond_to?(:errors) && !(name.nil? || object.errors[name].empty?)
    end

    def form_group_builder(method, options, html_options = nil)
      options.symbolize_keys!
      html_options.symbolize_keys! if html_options

      # Add control_class; allow it to be overridden by :control_class option
      css_options = html_options || options
      control_classes = css_options.delete(:control_class) { control_class }
      css_options[:class] = [control_classes, css_options[:class]].compact.join(" ")

      label = options.delete(:label)
      label_class = hide_class if options.delete(:hide_label)
      help = options.delete(:help)
      left = options.delete(:left)
      right = options.delete(:right)

      form_group(method, label: { text: label, class: label_class }, help: help, left: left, right: right) do
        yield
      end
    end

    def generate_label(name, options, configuration_options = nil)
      if options
        label(name, options[:text], options.except(:text))
      elsif horizontal?
        # no label. create an empty one to keep proper form alignment.
        content_tag(:label, "", class: "#{label_class} #{left_class}")
      end
    end

    def generate_help(name, help_text)
      help_text = object.errors[name].join(", ") if has_error?(name) && inline_errors
      content_tag(:span, help_text, class: "help-block") if help_text
    end

    def inputs_collection(name, collection, value, text, options = {}, &block)
      form_group_builder(name, options) do
        inputs = ""

        collection.each do |obj|
          input_options = options.merge(label: obj.send(text))
          input_options.delete(:class)
          inputs << block.call(name, obj.send(value), input_options)
        end

        inputs.html_safe
      end
    end
  end
end
