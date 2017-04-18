require_relative 'aliasing'
require_relative 'helpers/bootstrap'

module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    extend BootstrapForm::Aliasing
    include BootstrapForm::Helpers::Bootstrap

    attr_reader :layout, :label_col, :control_col, :has_error, :inline_errors, :label_errors, :acts_like_form_tag

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
      @label_errors = options[:label_errors] || false
      @inline_errors = if options[:inline_errors].nil?
        @label_errors != true
      else
        options[:inline_errors] != false
      end
      @acts_like_form_tag = options[:acts_like_form_tag]

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

      bootstrap_method_alias method_name
    end

    DATE_SELECT_HELPERS.each do |method_name|
      with_method_name = "#{method_name}_with_bootstrap"
      without_method_name = "#{method_name}_without_bootstrap"

      define_method(with_method_name) do |name, options = {}, html_options = {}|
        form_group_builder(name, options, html_options) do
          content_tag(:div, send(without_method_name, name, options, html_options), class: control_specific_class(method_name))
        end
      end

      bootstrap_method_alias method_name
    end

    def file_field_with_bootstrap(name, options = {})
      form_group_builder(name, options.reverse_merge(control_class: nil)) do
        file_field_without_bootstrap(name, options)
      end
    end

    bootstrap_method_alias :file_field

    if Gem::Version.new(Rails::VERSION::STRING) >= Gem::Version.new("4.1.0")
      def select_with_bootstrap(method, choices = nil, options = {}, html_options = {}, &block)
        form_group_builder(method, options, html_options) do
          prepend_and_append_input(options) do
            select_without_bootstrap(method, choices, options, html_options, &block)
          end
        end
      end
    else
      def select_with_bootstrap(method, choices, options = {}, html_options = {})
        form_group_builder(method, options, html_options) do
          prepend_and_append_input(options) do
            select_without_bootstrap(method, choices, options, html_options)
          end
        end
      end
    end

    bootstrap_method_alias :select

    def collection_select_with_bootstrap(method, collection, value_method, text_method, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        collection_select_without_bootstrap(method, collection, value_method, text_method, options, html_options)
      end
    end

    bootstrap_method_alias :collection_select

    def grouped_collection_select_with_bootstrap(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        grouped_collection_select_without_bootstrap(method, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
      end
    end

    bootstrap_method_alias :grouped_collection_select

    def time_zone_select_with_bootstrap(method, priority_zones = nil, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        time_zone_select_without_bootstrap(method, priority_zones, options, html_options)
      end
    end

    bootstrap_method_alias :time_zone_select

    def check_box_with_bootstrap(name, options = {}, checked_value = "1", unchecked_value = "0", &block)
      options = options.symbolize_keys!
      check_box_options = options.except(:label, :label_class, :help, :inline)

      html = check_box_without_bootstrap(name, check_box_options, checked_value, unchecked_value)
      label_content = block_given? ? capture(&block) : options[:label]
      html.concat(" ").concat(label_content || (object && object.class.human_attribute_name(name)) || name.to_s.humanize)

      label_name = name
      # label's `for` attribute needs to match checkbox tag's id,
      # IE sanitized value, IE
      # https://github.com/rails/rails/blob/c57e7239a8b82957bcb07534cb7c1a3dcef71864/actionview/lib/action_view/helpers/tags/base.rb#L116-L118
      if options[:multiple]
        label_name =
          "#{name}_#{checked_value.to_s.gsub(/\s/, "_").gsub(/[^-\w]/, "").downcase}"
      end

      disabled_class = " disabled" if options[:disabled]
      label_class    = options[:label_class]

      if options[:inline]
        label_class = " #{label_class}" if label_class
        label(label_name, html, class: "checkbox-inline#{disabled_class}#{label_class}")
      else
        content_tag(:div, class: "checkbox#{disabled_class}") do
          label(label_name, html, class: label_class)
        end
      end
    end

    bootstrap_method_alias :check_box

    def radio_button_with_bootstrap(name, value, *args)
      options = args.extract_options!.symbolize_keys!
      args << options.except(:label, :label_class, :help, :inline)

      html = radio_button_without_bootstrap(name, value, *args) + " " + options[:label]

      disabled_class = " disabled" if options[:disabled]
      label_class    = options[:label_class]

      if options[:inline]
        label_class = " #{label_class}" if label_class
        label(name, html, class: "radio-inline#{disabled_class}#{label_class}", value: value)
      else
        content_tag(:div, class: "radio#{disabled_class}") do
          label(name, html, value: value, class: label_class)
        end
      end
    end

    bootstrap_method_alias :radio_button

    def collection_check_boxes_with_bootstrap(*args)
      html = inputs_collection(*args) do |name, value, options|
        options[:multiple] = true
        check_box(name, options, value, nil)
      end
      hidden_field(args.first,{value: "", multiple: true}).concat(html)
    end

    bootstrap_method_alias :collection_check_boxes

    def collection_radio_buttons_with_bootstrap(*args)
      inputs_collection(*args) do |name, value, options|
        radio_button(name, value, options)
      end
    end

    bootstrap_method_alias :collection_radio_buttons

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
      options[:class] << " #{feedback_class}" if options[:icon]

      content_tag(:div, options.except(:id, :label, :help, :icon, :label_col, :control_col, :layout)) do
        label = generate_label(options[:id], name, options[:label], options[:label_col], options[:layout]) if options[:label]
        control = capture(&block).to_s
        control.concat(generate_help(name, options[:help]).to_s)
        control.concat(generate_icon(options[:icon])) if options[:icon]

        if get_group_layout(options[:layout]) == :horizontal
          control_class = options[:control_col] || control_col
          unless options[:label]
            control_offset = offset_col(options[:label_col] || @label_col)
            control_class = "#{control_class} #{control_offset}"
          end
          control = content_tag(:div, control, class: control_class)
        end

        concat(label).concat(control)
      end
    end

    def fields_for_with_bootstrap(record_name, record_object = nil, fields_options = {}, &block)
      fields_options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?
      fields_options[:layout] ||= options[:layout]
      fields_options[:label_col] = fields_options[:label_col].present? ? "#{fields_options[:label_col]} #{label_class}" : options[:label_col]
      fields_options[:control_col] ||= options[:control_col]
      fields_options[:inline_errors] ||= options[:inline_errors]
      fields_options[:label_errors] ||= options[:label_errors]
      fields_for_without_bootstrap(record_name, record_object, fields_options, &block)
    end

    bootstrap_method_alias :fields_for

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

    def offset_col(label_col)
      label_col.sub(/^col-(\w+)-(\d)$/, 'col-\1-offset-\2')
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

    def feedback_class
      "has-feedback"
    end

    def control_specific_class(method)
      "rails-bootstrap-forms-#{method.gsub(/_/, "-")}"
    end

    def has_error?(name)
      object.respond_to?(:errors) && !(name.nil? || object.errors[name].empty?)
    end

    def required_attribute?(obj, attribute)

      return false unless obj and attribute

      target = (obj.class == Class) ? obj : obj.class

      target_validators = if target.respond_to? :validators_on
                            target.validators_on(attribute).map(&:class)
                          else
                            []
                          end

      has_presence_validator = target_validators.include?(
                                 ActiveModel::Validations::PresenceValidator)

      if defined? ActiveRecord::Validations::PresenceValidator
        has_presence_validator |= target_validators.include?(
                                    ActiveRecord::Validations::PresenceValidator)
      end

      has_presence_validator
    end

    def form_group_builder(method, options, html_options = nil)
      options.symbolize_keys!
      html_options.symbolize_keys! if html_options

      # Add control_class; allow it to be overridden by :control_class option
      css_options = html_options || options
      control_classes = css_options.delete(:control_class) { control_class }
      css_options[:class] = [control_classes, css_options[:class]].compact.join(" ")

      options = convert_form_tag_options(method, options) if acts_like_form_tag

      wrapper_class = css_options.delete(:wrapper_class)
      wrapper_options = css_options.delete(:wrapper)
      help = options.delete(:help)
      icon = options.delete(:icon)
      label_col = options.delete(:label_col)
      control_col = options.delete(:control_col)
      layout = get_group_layout(options.delete(:layout))
      form_group_options = {
        id: options[:id],
        help: help,
        icon: icon,
        label_col: label_col,
        control_col: control_col,
        layout: layout,
        class: wrapper_class
      }

      if wrapper_options.is_a?(Hash)
        form_group_options.merge!(wrapper_options)
      end

      unless options.delete(:skip_label)
        if options[:label].is_a?(Hash)
          label_text  = options[:label].delete(:text)
          label_class = options[:label].delete(:class)
          options.delete(:label)
        end
        label_class ||= options.delete(:label_class)
        label_class = hide_class if options.delete(:hide_label)

        if options[:label].is_a?(String)
          label_text ||= options.delete(:label)
        end

        form_group_options.merge!(label: {
          text: label_text,
          class: label_class,
          skip_required: options.delete(:skip_required)
        })
      end

      form_group(method, form_group_options) do
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
      unless options.delete(:skip_required)
        classes << "required" if required_attribute?(object, name)
      end

      options[:class] = classes.compact.join(" ")

      if label_errors && has_error?(name)
        error_messages = get_error_messages(name)
        label_text = (options[:text] || object.class.human_attribute_name(name)).to_s.concat(" #{error_messages}")
        label(name, label_text, options.except(:text))
      else
        label(name, options[:text], options.except(:text))
      end

    end

    def generate_help(name, help_text)
      help_text = get_error_messages(name) if has_error?(name) && inline_errors
      return if help_text === false

      help_text ||= get_help_text_by_i18n_key(name)

      content_tag(:span, help_text, class: 'help-block') if help_text.present?
    end

    def generate_icon(icon)
      content_tag(:span, "", class: "glyphicon glyphicon-#{icon} form-control-feedback")
    end

    def get_error_messages(name)
      object.errors[name].join(", ")
    end

    def inputs_collection(name, collection, value, text, options = {}, &block)
      form_group_builder(name, options) do
        inputs = ""

        collection.each do |obj|
          input_options = options.merge(label: text.respond_to?(:call) ? text.call(obj) : obj.send(text))

          input_value = value.respond_to?(:call) ? value.call(obj) : obj.send(value)
          if checked = input_options[:checked]
            input_options[:checked] = checked == input_value                     ||
                                      Array(checked).try(:include?, input_value) ||
                                      checked == obj                             ||
                                      Array(checked).try(:include?, obj)
          end

          input_options.delete(:class)
          inputs << block.call(name, input_value, input_options)
        end

        inputs.html_safe
      end
    end

    def get_help_text_by_i18n_key(name)
      if object

        if object.class.respond_to?(:model_name)
          # ActiveModel::Naming 3.X.X does not support .name; it is supported as of 4.X.X
          partial_scope = object.class.model_name.respond_to?(:name) ? object.class.model_name.name : object.class.model_name
        else
          partial_scope = object.class.name
        end

        underscored_scope = "activerecord.help.#{partial_scope.underscore}"
        downcased_scope = "activerecord.help.#{partial_scope.downcase}"
        help_text = I18n.t(name, scope: underscored_scope, default: '').presence
        help_text ||= if text = I18n.t(name, scope: downcased_scope, default: '').presence
                        warn "I18n key '#{downcased_scope}.#{name}' is deprecated, use '#{underscored_scope}.#{name}' instead"
                        text
                      end
        help_text
      end
    end

  end
end
