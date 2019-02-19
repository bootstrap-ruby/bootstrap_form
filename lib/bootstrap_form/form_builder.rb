# require 'bootstrap_form/aliasing'

module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :layout, :label_col, :control_col, :has_error, :inline_errors,
                :label_errors, :acts_like_form_tag

    include BootstrapForm::Helpers::Bootstrap

    include BootstrapForm::Inputs::Base
    include BootstrapForm::Inputs::CheckBox
    include BootstrapForm::Inputs::CollectionCheckBoxes
    include BootstrapForm::Inputs::CollectionRadioButtons
    include BootstrapForm::Inputs::CollectionSelect
    include BootstrapForm::Inputs::ColorField
    include BootstrapForm::Inputs::DateField
    include BootstrapForm::Inputs::DateSelect
    include BootstrapForm::Inputs::DatetimeField
    include BootstrapForm::Inputs::DatetimeLocalField
    include BootstrapForm::Inputs::DatetimeSelect
    include BootstrapForm::Inputs::EmailField
    include BootstrapForm::Inputs::FileField
    include BootstrapForm::Inputs::GroupedCollectionSelect
    include BootstrapForm::Inputs::MonthField
    include BootstrapForm::Inputs::NumberField
    include BootstrapForm::Inputs::PasswordField
    include BootstrapForm::Inputs::PhoneField
    include BootstrapForm::Inputs::RadioButton
    include BootstrapForm::Inputs::RangeField
    include BootstrapForm::Inputs::RichTextArea if Rails::VERSION::MAJOR >= 6
    include BootstrapForm::Inputs::SearchField
    include BootstrapForm::Inputs::Select
    include BootstrapForm::Inputs::TelephoneField
    include BootstrapForm::Inputs::TextArea
    include BootstrapForm::Inputs::TextField
    include BootstrapForm::Inputs::TimeField
    include BootstrapForm::Inputs::TimeSelect
    include BootstrapForm::Inputs::TimeZoneSelect
    include BootstrapForm::Inputs::UrlField
    include BootstrapForm::Inputs::WeekField

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

    def form_group(*args, &block)
      options = args.extract_options!
      name = args.first

      options[:class] = form_group_classes(options)

      content_tag(:div, options.except(:append, :id, :label, :help, :icon,
                                       :input_group_class, :label_col, :control_col,
                                       :add_control_col_class, :layout, :prepend)) do
        form_group_content(
          generate_label(options[:id], name, options[:label], options[:label_col], options[:layout]),
          generate_help(name, options[:help]), options, &block
        )
      end
    end

    def fields_for_with_bootstrap(record_name, record_object=nil, fields_options={}, &block)
      fields_options = fields_for_options(record_object, fields_options)
      record_object.is_a?(Hash) && record_object.extractable_options? &&
        record_object = nil
      fields_for_without_bootstrap(record_name, record_object, fields_options, &block)
    end

    bootstrap_alias :fields_for

    # the Rails `fields` method passes its options
    # to the builder, so there is no need to write a `bootstrap_form` helper
    # for the `fields` method.

    private

    def form_group_content(label, help_text, options, &block)
      if group_layout_horizontal?(options[:layout])
        concat(label).concat(content_tag(:div, capture(&block) + help_text, class: form_group_control_class(options)))
      else
        concat(label).concat(capture(&block)).concat(help_text)
      end
    end

    def form_group_control_class(options)
      classes = [options[:control_col] || control_col]
      classes << options[:add_control_col_class] if options[:add_control_col_class]
      classes << offset_col(options[:label_col] || @label_col) unless options[:label]
      classes.flatten.compact
    end

    def form_group_classes(options)
      classes = ["form-group", options[:class].try(:split)].flatten.compact
      classes << "row" if group_layout_horizontal?(options[:layout]) && classes.exclude?("form-row")
      classes << "form-inline" if field_inline_override?(options[:layout])
      classes << feedback_class if options[:icon]
      classes
    end

    def group_layout_horizontal?(layout)
      get_group_layout(layout) == :horizontal
    end

    def fields_for_options(record_object, fields_options)
      field_options = fields_options
      record_object.is_a?(Hash) && record_object.extractable_options? &&
        field_options = record_object
      %i[layout control_col inline_errors label_errors].each do |option|
        field_options[option] ||= options[option]
      end
      field_options[:label_col] = field_options[:label_col].present? ? (field_options[:label_col]).to_s : options[:label_col]
      field_options
    end

    def layout_default?(field_layout=nil)
      [:default, nil].include? layout_in_effect(field_layout)
    end

    def layout_horizontal?(field_layout=nil)
      layout_in_effect(field_layout) == :horizontal
    end

    def layout_inline?(field_layout=nil)
      layout_in_effect(field_layout) == :inline
    end

    def field_inline_override?(field_layout=nil)
      field_layout == :inline && layout != :inline
    end

    # true and false should only come from check_box and radio_button,
    # and those don't have a :horizontal layout
    def layout_in_effect(field_layout)
      field_layout = :inline if field_layout == true
      field_layout = :default if field_layout == false
      field_layout || layout
    end

    def get_group_layout(group_layout)
      group_layout || layout
    end

    def default_label_col
      "col-sm-2"
    end

    def offset_col(label_col)
      label_col.gsub(/\bcol-(\w+)-(\d)\b/, 'offset-\1-\2')
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

    def feedback_class
      "has-feedback"
    end

    def control_specific_class(method)
      "rails-bootstrap-forms-#{method.to_s.tr('_', '-')}"
    end

    def has_error?(name)
      object.respond_to?(:errors) && !(name.nil? || object.errors[name].empty?)
    end

    def required_attribute?(obj, attribute)
      return false unless obj && attribute

      target = obj.class == Class ? obj : obj.class

      target_validators = if target.respond_to? :validators_on
                            target.validators_on(attribute).map(&:class)
                          else
                            []
                          end

      has_presence_validator = target_validators.include?(
        ActiveModel::Validations::PresenceValidator
      )

      if defined? ActiveRecord::Validations::PresenceValidator
        has_presence_validator |= target_validators.include?(
          ActiveRecord::Validations::PresenceValidator
        )
      end

      has_presence_validator
    end

    def form_group_builder(method, options, html_options=nil)
      options.symbolize_keys!
      options = convert_form_tag_options(method, options) if acts_like_form_tag
      wrapper_options = options[:wrapper] == false
      css_options = form_group_css_options(method, html_options.try(:symbolize_keys!), options)

      unless options[:skip_label]
        options[:required] = form_group_required(options) if options.key?(:skip_required)
      end

      form_group_options = form_group_opts(options, css_options)

      options.except!(
        :help, :icon, :label_col, :control_col, :add_control_col_class, :layout, :skip_label, :label, :label_class,
        :hide_label, :skip_required, :label_as_placeholder, :wrapper_class, :wrapper
      )

      if wrapper_options
        yield
      else
        form_group(method, form_group_options) do
          yield
        end
      end
    end

    def form_group_opts(options, css_options)
      wrapper_options = options[:wrapper]
      form_group_options = {
        id: options[:id],
        help: options[:help],
        icon: options[:icon],
        label_col: options[:label_col],
        control_col: options[:control_col],
        add_control_col_class: options[:add_control_col_class],
        layout: get_group_layout(options[:layout]),
        class: options[:wrapper_class]
      }

      form_group_options.merge!(wrapper_options) if wrapper_options.is_a?(Hash)
      form_group_options[:label] = form_group_label(options, css_options) unless options[:skip_label]
      form_group_options
    end

    def form_group_label(options, css_options)
      hash = {
        text: form_group_label_text(options[:label]),
        class: form_group_label_class(options),
        required: options[:required]
      }.merge(css_options[:id].present? ? { for: css_options[:id] } : {})
      hash
    end

    def form_group_label_text(label)
      text = label[:text] if label.is_a?(Hash)
      text ||= label if label.is_a?(String)
      text
    end

    def form_group_label_class(options)
      return hide_class if options[:hide_label] || options[:label_as_placeholder]

      classes = options[:label][:class] if options[:label].is_a?(Hash)
      classes ||= options[:label_class]
      classes
    end

    def form_group_required(options)
      if options.key?(:skip_required)
        warn "`:skip_required` is deprecated, use `:required: false` instead"
        options[:skip_required] ? false : :default
      end
    end

    def form_group_css_options(method, html_options, options)
      css_options = html_options || options
      # Add control_class; allow it to be overridden by :control_class option
      control_classes = css_options.delete(:control_class) { control_class }
      css_options[:class] = [control_classes, css_options[:class]].compact.join(" ")
      css_options[:class] << " is-invalid" if has_error?(method)
      css_options[:placeholder] = form_group_placeholder(options, method) if options[:label_as_placeholder]
      css_options
    end

    def form_group_placeholder(options, method)
      form_group_label_text(options[:label]) || object.class.human_attribute_name(method)
    end

    def convert_form_tag_options(method, options={})
      unless @options[:skip_default_ids]
        options[:name] ||= method
        options[:id] ||= method
      end
      options
    end

    def generate_label(id, name, options, custom_label_col, group_layout)
      return if options.blank?

      # id is the caller's options[:id] at the only place this method is called.
      # The options argument is a small subset of the options that might have
      # been passed to generate_label's caller, and definitely doesn't include
      # :id.
      options[:for] = id if acts_like_form_tag

      options[:class] = label_classes(name, options, custom_label_col, group_layout)
      options.delete(:class) if options[:class].none?

      label(name, label_text(name, options), options.except(:text))
    end

    def label_classes(name, options, custom_label_col, group_layout)
      classes = [options[:class], label_layout_classes(custom_label_col, group_layout)]

      case options.delete(:required)
      when true
        classes << "required"
      when nil, :default
        classes << "required" if required_attribute?(object, name)
      end

      classes << "text-danger" if label_errors && has_error?(name)
      classes.flatten.compact
    end

    def label_layout_classes(custom_label_col, group_layout)
      if layout_horizontal?(group_layout)
        ["col-form-label", (custom_label_col || label_col)]
      elsif layout_inline?(group_layout)
        ["mr-sm-2"]
      end
    end

    def label_text(name, options)
      if label_errors && has_error?(name)
        (options[:text] || object.class.human_attribute_name(name)).to_s.concat(" #{get_error_messages(name)}")
      else
        options[:text]
      end
    end

    def has_inline_error?(name)
      has_error?(name) && inline_errors
    end

    def generate_error(name)
      if has_inline_error?(name)
        help_text = get_error_messages(name)
        help_klass = "invalid-feedback"
        help_tag = :div

        content_tag(help_tag, help_text, class: help_klass)
      else
        ""
      end
    end

    def generate_help(name, help_text)
      return if help_text == false || has_inline_error?(name)

      help_klass ||= "form-text text-muted"
      help_text ||= get_help_text_by_i18n_key(name)
      help_tag ||= :small

      content_tag(help_tag, help_text, class: help_klass) if help_text.present?
    end

    def get_error_messages(name)
      object.errors[name].join(", ")
    end

    def inputs_collection(name, collection, value, text, options={})
      options[:inline] ||= layout_inline?(options[:layout])

      form_group_builder(name, options) do
        inputs = ""

        collection.each_with_index do |obj, i|
          input_value = value.respond_to?(:call) ? value.call(obj) : obj.send(value)
          input_options = form_group_collection_input_options(options, text, obj, i, input_value, collection)
          inputs << yield(name, input_value, input_options)
        end

        inputs.html_safe
      end
    end

    def form_group_collection_input_options(options, text, obj, index, input_value, collection)
      input_options = options.merge(label: text.respond_to?(:call) ? text.call(obj) : obj.send(text))
      if (checked = input_options[:checked])
        input_options[:checked] = form_group_collection_input_checked?(checked, obj, input_value)
      end

      input_options[:error_message] = index == collection.size - 1
      input_options.except!(:class)
      input_options
    end

    def form_group_collection_input_checked?(checked, obj, input_value)
      checked == input_value || Array(checked).try(:include?, input_value) ||
        checked == obj || Array(checked).try(:include?, obj)
    end

    def get_help_text_by_i18n_key(name)
      return unless object

      partial_scope = if object.class.respond_to?(:model_name)
                        object.class.model_name.name
                      else
                        object.class.name
                      end

      # First check for a subkey :html, as it is also accepted by i18n, and the
      # simple check for name would return an hash instead of a string (both
      # with .presence returning true!)
      help_text = nil
      ["#{name}.html", name, "#{name}_html"].each do |scope|
        break if help_text

        help_text = scoped_help_text(scope, partial_scope)
      end
      help_text
    end

    def scoped_help_text(name, partial_scope)
      underscored_scope = "activerecord.help.#{partial_scope.underscore}"
      downcased_scope = "activerecord.help.#{partial_scope.downcase}"

      help_text = I18n.t(name, scope: underscored_scope, default: "").html_safe.presence

      help_text ||= if (text = I18n.t(name, scope: downcased_scope, default: "").html_safe.presence)
                      warn "I18n key '#{downcased_scope}.#{name}' is deprecated, use '#{underscored_scope}.#{name}' instead"
                      text
                    end

      help_text
    end
  end
end
