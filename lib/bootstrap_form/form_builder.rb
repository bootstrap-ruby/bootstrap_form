require_relative 'helpers/bootstrap'

module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    include BootstrapForm::Helpers::Bootstrap

    attr_reader :layout, :label_col, :control_col, :has_error, :inline_errors, :acts_like_form_tag, :icons

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
      @icons = options[:icons]
      super
    end

    FIELD_HELPERS.each do |method_name|
      with_method_name = "#{method_name}_with_bootstrap"
      without_method_name = "#{method_name}_without_bootstrap"

      define_method(with_method_name) do |name, options = {}|
        form_group_builder(name, options) do
          prepend_and_append_input(options) do
            send(without_method_name, name, options)
          end
        end
      end

      alias_method_chain method_name, :bootstrap
    end

    DATE_SELECT_HELPERS.each do |method_name|
      with_method_name = "#{method_name}_with_bootstrap"
      without_method_name = "#{method_name}_without_bootstrap"

      define_method(with_method_name) do |name, options = {}, html_options = {}|
        form_group_builder(name, options, html_options) do
          content_tag(:div, send(without_method_name, name, options, html_options), class: control_specific_class(method_name))
        end
      end

      alias_method_chain method_name, :bootstrap
    end

    def file_field_with_bootstrap(name, options = {})
      form_group_builder(name, options.reverse_merge(control_class: nil)) do
        file_field_without_bootstrap(name, options)
      end
    end

    alias_method_chain :file_field, :bootstrap

    def select_with_bootstrap(method, choices, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        select_without_bootstrap(method, choices, options, html_options)
      end
    end

    alias_method_chain :select, :bootstrap

    def collection_select_with_bootstrap(method, collection, value_method, text_method, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        collection_select_without_bootstrap(method, collection, value_method, text_method, options, html_options)
      end
    end

    alias_method_chain :collection_select, :bootstrap

    def grouped_collection_select_with_bootstrap(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        grouped_collection_select_without_bootstrap(method, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
      end
    end

    alias_method_chain :grouped_collection_select, :bootstrap

    def time_zone_select_with_bootstrap(method, priority_zones = nil, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        time_zone_select_without_bootstrap(method, priority_zones, options, html_options)
      end
    end

    alias_method_chain :time_zone_select, :bootstrap

    def check_box_with_bootstrap(name, options = {}, checked_value = "1", unchecked_value = "0", &block)
      options = options.symbolize_keys!

      html = check_box_without_bootstrap(name, options.except(:label, :help, :inline), checked_value, unchecked_value)
      label_content = block_given? ? capture(&block) : options[:label]
      html.concat(" ").concat(label_content || (object && object.class.human_attribute_name(name)) || name.to_s.humanize)

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

    alias_method_chain :check_box, :bootstrap

    def radio_button_with_bootstrap(name, value, *args)
      options = args.extract_options!.symbolize_keys!
      args << options.except(:label, :help, :inline)

      html = radio_button_without_bootstrap(name, value, *args) + " " + options[:label]

      if options[:inline]
        label(name, html, class: "radio-inline", value: value)
      else
        content_tag(:div, class: "radio") do
          label(name, html, value: value)
        end
      end
    end

    alias_method_chain :radio_button, :bootstrap

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
      name = args.first

      options[:class] = ["form-group", options[:class]].compact.join(' ')
      options[:class] << " #{error_class}" if has_error?(name)

      content_tag(:div, options.except(:id, :label, :help, :label_col, :control_col, :layout, :icon)) do
        label   = generate_label(options[:id], name, options[:label], options[:label_col], options[:layout]) if options[:label]
        control = capture(&block).to_s
        help    = generate_help(name, options[:help]).to_s
        icon    = options.delete(:icon)
        control_and_help = control.concat(help)


        if icon
          icon = generate_icon(icon)
          control_and_help = control_and_help.concat(icon)
        end

        if get_group_layout(options[:layout]) == :horizontal
          control_class = (options[:control_col] || control_col)

          unless options[:label]
            control_offset = offset_col(/([0-9]+)$/.match(options[:label_col] || default_label_col))
            control_class.concat(" #{control_offset}")
          end
          control_and_help = content_tag(:div, control_and_help, class: control_class)
        end

        concat(label).concat(control_and_help)
      end
    end

    def fields_for_with_bootstrap(record_name, record_object = nil, fields_options = {}, &block)
      fields_options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?
      fields_options[:layout] ||= options[:layout]
      fields_options[:label_col] = fields_options[:label_col].present? ? "#{fields_options[:label_col]} #{label_class}" : options[:label_col]
      fields_options[:control_col] ||= options[:control_col]
      fields_for_without_bootstrap(record_name, record_object, fields_options, &block)
    end

    alias_method_chain :fields_for, :bootstrap

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

    def offset_col(offset)
      "col-sm-offset-#{offset}"
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

    def success_class
      "has-success"
    end

    def has_feedback_class
      "has-feedback"
    end

    def default_success_icon
      "ok"
    end

    def default_error_icon
      "remove"
    end

    def control_specific_class(method)
      "rails-bootstrap-forms-#{method.gsub(/_/, "-")}"
    end

    def has_error?(name)
      object.respond_to?(:errors) && !(name.nil? || object.errors[name].empty?)
    end

    def has_success?(name)
      object.respond_to?(:errors) && object.respond_to?(name) && object.changed? &&  object.errors[name].empty?
    end

    def default_validation_or_user_defined_icon(icon, name)
      return nil if icon === false
      if icon === true
        return default_error_icon if has_error?(name)
        return default_success_icon if has_success?(name)
        return nil
      end

      if icon.is_a?(Hash)
        if has_error?(name)
          return nil if icon[:error] === false
          return icon[:error] || default_error_icon
        end

        if has_success?(name)
          return nil if icon[:success] === false
          return icon[:success] || default_error_icon
        end

        return nil if icon[:default] === false
        return icon[:default] || nil
      end

      return icon if icon
      return default_error_icon if has_error?(name)
      return default_success_icon if has_success?(name)
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
      wrapper_class = options.delete(:wrapper_class)

      icon = options.delete(:icon)
      icon = @icons if !(icon===false) && @icons
      icon = default_validation_or_user_defined_icon(icon, method) if icon
      wrapper_class = "#{wrapper_class} #{has_feedback_class}" if icon

      help = options.delete(:help)
      label_col = options.delete(:label_col)
      control_col = options.delete(:control_col)
      layout = get_group_layout(options.delete(:layout))

      form_group(method, id: options[:id], label: { text: label, class: label_class }, help: help, label_col: label_col, control_col: control_col, layout: layout, class: wrapper_class, icon: icon) do
        yield
      end
    end

    def convert_form_tag_options(method, options = {})
      options[:name] ||= method
      options[:id] ||= method
      options
    end

    def generate_label(id, name, options, custom_label_col, group_layout)
      options[:for] = id if acts_like_form_tag
      classes = [options[:class], label_class]
      classes << (custom_label_col || label_col) if get_group_layout(group_layout) == :horizontal
      options[:class] = classes.compact.join(" ")

      label(name, options[:text], options.except(:text))
    end

    def generate_help(name, help_text)
      help_text = object.errors[name].join(", ") if has_error?(name) && inline_errors
      content_tag(:span, help_text, class: "help-block") if help_text
    end

    def generate_icon(icon)
      content_tag(:span, nil, class: "glyphicon glyphicon-#{icon} form-control-feedback") if icon
    end

    def inputs_collection(name, collection, value, text, options = {}, &block)
      form_group_builder(name, options) do
        inputs = ""

        collection.each do |obj|
          input_options = options.merge(label: obj.send(text))

          if checked = input_options[:checked]
            input_options[:checked] = checked == obj.send(value)              ||
                                      checked.try(:include?, obj.send(value)) ||
                                      checked == obj                          ||
                                      checked.try(:include?, obj)
          end

          input_options.delete(:class)
          inputs << block.call(name, obj.send(value), input_options)
        end

        inputs.html_safe
      end
    end
  end
end
