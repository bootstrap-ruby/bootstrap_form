# require 'bootstrap_form/aliasing'

module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :layout, :label_col, :control_col, :has_error, :inline_errors,
                :label_errors, :acts_like_form_tag

    include BootstrapForm::Helpers::Bootstrap

    include BootstrapForm::FormGroupBuilder
    include BootstrapForm::FormGroup
    include BootstrapForm::Components

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

    delegate :content_tag, :capture, :concat, :tag, to: :@template

    def initialize(object_name, object, template, options)
      @layout = options[:layout] || default_layout
      @label_col = options[:label_col] || default_label_col
      @control_col = options[:control_col] || default_control_col
      @label_errors = options[:label_errors] || false

      @inline_errors = if options[:inline_errors].nil?
                         @label_errors != true
                       else
                         options[:inline_errors] != false
                       end
      @acts_like_form_tag = options[:acts_like_form_tag]
      add_default_form_attributes_and_form_inline options
      super
    end

    def add_default_form_attributes_and_form_inline(options)
      options[:html] ||= {}
      options[:html].reverse_merge!(BootstrapForm.config.default_form_attributes)

      return unless options[:layout] == :inline

      options[:html][:class] =
        ([*options[:html][:class]&.split(/\s+/)] + %w[row row-cols-auto g-3 align-items-center])
        .compact.uniq.join(" ")
    end

    def fields_for_with_bootstrap(record_name, record_object=nil, fields_options={}, &block)
      fields_options = fields_for_options(record_object, fields_options)
      record_object = nil if record_object.is_a?(Hash) && record_object.extractable_options?
      fields_for_without_bootstrap(record_name, record_object, fields_options, &block)
    end

    bootstrap_alias :fields_for

    # the Rails `fields` method passes its options
    # to the builder, so there is no need to write a `bootstrap_form` helper
    # for the `fields` method.

    private

    def fields_for_options(record_object, fields_options)
      field_options = fields_options
      field_options = record_object if record_object.is_a?(Hash) && record_object.extractable_options?
      %i[layout control_col inline_errors label_errors].each do |option|
        field_options[option] ||= options[option]
      end
      field_options[:label_col] = field_options[:label_col].present? ? (field_options[:label_col]).to_s : options[:label_col]
      field_options
    end

    def default_layout
      # :default, :horizontal or :inline
      :default
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
      "visually-hidden" # still accessible for screen readers
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
  end
end
