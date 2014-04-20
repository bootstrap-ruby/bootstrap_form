require_relative 'helpers/bootstrap'

module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    include BootstrapForm::Helpers::Bootstrap

    attr_reader :layout, :label_col, :control_col, :has_error, :inline_errors, :acts_like_form_tag

    FIELD_HELPERS = %w{color_field date_field datetime_field datetime_local_field
      email_field month_field number_field password_field phone_field
      range_field search_field telephone_field text_area text_field time_field
      url_field week_field}

    DATE_SELECT_HELPERS = %w{date_select time_select datetime_select}

    delegate :content_tag, :capture, :concat, to: :@template

    def initialize(object_name, object, template, options)
      @layout = options[:layout]
      @label_col = options[:label_col] || default_label_col
      @control_col = options[:control_col] || default_control_col
      @inline_errors = options[:inline_errors] != false
      @acts_like_form_tag = options[:acts_like_form_tag]

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

    def grouped_collection_select(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        super(method, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
      end
    end

    def check_box(name, options = {}, checked_value = "1", unchecked_value = "0", &block)
      options = options.symbolize_keys!

      html = super(name, options.except(:label, :help, :inline), checked_value, unchecked_value)
      label_content = block_given? ? capture(&block) : options[:label]
      html.concat(" ").concat(label_content || object.class.human_attribute_name(name) || name.to_s.humanize)

      label_name = name
      label_name = "#{name}_#{checked_value}" if options[:multiple]

      if options[:inline]
        label(label_name, html, class: "checkbox-inline")
      else
        content_tag(:div, class: "checkbox") do
          label(label_name, html)
        end
      end
    end

    def radio_button(name, value, *args)
      options = args.extract_options!.symbolize_keys!
      args << options.except(:label, :help, :inline)

      html = super(name, value, *args) + " " + options[:label]

      css = "radio"
      css << "-inline" if options[:inline]
      label(name, html, class: css, for: nil)
    end

    def collection_check_boxes(*args)
      inputs_collection(*args) do |name, value, options|
        options[:multiple] = true
        check_box(name, options, value, nil)
      end
    end

    def collection_radio_buttons(*args)
      inputs_collection(*args) do |name, value, options|
        radio_button(name, value, options)
      end
    end

    def check_boxes_collection(*args)
      warn "'BootstrapForm#check_boxes_collection' is deprecated, use 'BootstrapForm#collection_check_boxes' instead"
      collection_check_boxes(*args)
    end

    def radio_buttons_collection(*args)
      warn "'BootstrapForm#radio_buttons_collection' is deprecated, use 'BootstrapForm#collection_radio_buttons' instead"
      collection_radio_buttons(*args)
    end

    def form_group(*args, &block)
      options = args.extract_options!
      name    = args.first
      
      options[:class] = ["form-group", options[:class]].compact.join(' ')
      options[:class] << " #{error_class}" if has_error?(name)

      content_tag(:div, options.except(:id, :label, :help, :label_col, :control_col, :layout)) do
        label = generate_label(options[:id], name, options[:label], options[:label_col], options[:layout])
        control_and_help = capture(&block).concat(generate_help(name, options[:help]))
        if get_group_layout(options[:layout]) == :horizontal
          control_and_help = content_tag(:div, control_and_help, class: (options[:control_col] || control_col))
        end
        concat(label).concat(control_and_help)
      end
    end

    def fields_for(record_name, record_object = nil, fields_options = {}, &block)
      fields_options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?
      fields_options[:layout] ||= options[:layout]
      fields_options[:label_col] = fields_options[:label_col].present? ? "#{fields_options[:label_col]} #{label_class}" : options[:label_col]
      fields_options[:control_col] ||= options[:control_col]
      super(record_name, record_object, fields_options, &block)
    end

    private

    def horizontal?
      layout == :horizontal
    end

    def get_group_layout(group_layout)
      group_layout || layout
    end

    def default_label_col
      "col-sm-2"
    end

    def default_control_col
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

    def error_class
      "has-error"
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

      options = convert_form_tag_options(method, options) if acts_like_form_tag

      label = options.delete(:label)
      label_class = hide_class if options.delete(:hide_label)
      help = options.delete(:help)
      label_col = options.delete(:label_col)
      control_col = options.delete(:control_col)
      layout = get_group_layout(options.delete(:layout))

      form_group(method, id: options[:id], label: { text: label, class: label_class }, help: help, label_col: label_col, control_col: control_col, layout: layout) do
        yield
      end
    end

    def convert_form_tag_options(method, options = {})
      options[:name] ||= method
      options[:id] ||= method
      options
    end

    def generate_label(id, name, options, custom_label_col, group_layout)
      if options
        options[:for] = id if acts_like_form_tag
        classes = [options[:class], label_class]
        classes << (custom_label_col || label_col) if get_group_layout(group_layout) == :horizontal
        options[:class] = classes.compact.join(" ")

        label(name, options[:text], options.except(:text))
      elsif get_group_layout(group_layout) == :horizontal
        # no label. create an empty one to keep proper form alignment.
        content_tag(:label, "", class: "#{label_class} #{label_col}")
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
          input_options[:checked] = input_options[:checked] == obj.send(value) if input_options[:checked]

          input_options.delete(:class)
          inputs << block.call(name, obj.send(value), input_options)
        end

        inputs.html_safe
      end
    end
  end
end
