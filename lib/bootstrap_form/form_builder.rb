# require 'bootstrap_form/aliasing'

module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :layout, :label_col, :control_col, :has_error, :inline_errors,
                :label_errors, :acts_like_form_tag

    include BootstrapForm::Helpers::Bootstrap

    include BootstrapForm::FormGroupBuilder
    include BootstrapForm::FormGroup

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

    def error?(name)
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

      presence_validator?(target_validators)
    end

    def presence_validator?(target_validators)
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

      classes << "text-danger" if label_errors && error?(name)
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
      if label_errors && error?(name)
        (options[:text] || object.class.human_attribute_name(name)).to_s.concat(" #{get_error_messages(name)}")
      else
        options[:text]
      end
    end

    def inline_error?(name)
      error?(name) && inline_errors
    end

    def generate_error(name)
      if inline_error?(name)
        help_text = get_error_messages(name)
        help_klass = "invalid-feedback"
        help_tag = :div

        content_tag(help_tag, help_text, class: help_klass)
      else
        ""
      end
    end

    def generate_help(name, help_text)
      return if help_text == false || inline_error?(name)

      help_klass ||= "form-text text-muted"
      help_text ||= get_help_text_by_i18n_key(name)
      help_tag ||= :small

      content_tag(help_tag, help_text, class: help_klass) if help_text.present?
    end

    def get_error_messages(name)
      object.errors[name].join(", ")
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

      help_text = translated_help_text(name, underscored_scope).presence

      help_text ||= if (text = translated_help_text(name, downcased_scope).presence)
                      warn "I18n key '#{downcased_scope}.#{name}' is deprecated, use '#{underscored_scope}.#{name}' instead"
                      text
                    end

      help_text
    end

    def translated_help_text(name, scope)
      ActiveSupport::SafeBuffer.new I18n.t(name, scope: scope, default: "")
    end
  end
end
