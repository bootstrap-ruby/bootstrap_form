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
      options = options.reverse_merge(control_class: 'form-control-file')
      form_group_builder(name, options) do
        file_field_without_bootstrap(name, options)
      end
    end

    bootstrap_method_alias :file_field

    def select_with_bootstrap(method, choices = nil, options = {}, html_options = {}, &block)
      form_group_builder(method, options, html_options) do
        prepend_and_append_input(options) do
          select_without_bootstrap(method, choices, options, html_options, &block)
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

    # @!macro [new] check_box_options
    #   @param options [Hash] Options processed by this method.
    #     Additional options are passed to the Rails helper as options.
    #   @option options [Boolean] :custom If true, generate HTML for a custom check
    #     box.
    #   @option options [String] :help Help text to add to the HTML.
    #   @option options [Boolean] :hide_label If true, hide the label and and mark it
    #     `sr-only` for screen readers.
    #   @option options [Boolean] :inline If true, place the label on the same line
    #     as the check box.
    #   @option options [String] :label Text to use for the label.
    #   @option options [String] :label_class A user-defined CSS class to add to
    #     the label element, in addition to the classes added by this method.
    #   @option options [Boolean] :skip_label If true, don't generate a label tag at all.
    #   @return [ActiveSupport::SafeBuffer] Bootstrap HTML for a check box

    # @overload check_box(name, options = {}, checked_value = "1", unchecked_value = "0", &block)
    # Generate Bootstrap markup for a check box.
    # @!macro check_box_options
    def check_box_with_bootstrap(name, options = {}, checked_value = "1", unchecked_value = "0", &block)
      options = options.symbolize_keys!
      check_box_options = options.except(:label, :label_class, :help, :inline, :custom)
      if options[:custom]
        validation = nil
        validation = "is-invalid" if has_error?(name)
        check_box_options[:class] = ["custom-control-input", validation, check_box_options[:class]].compact.join(' ')
      else
        check_box_options[:class] = ["form-check-input", check_box_options[:class]].compact.join(' ')
      end

      checkbox_html = check_box_without_bootstrap(name, check_box_options, checked_value, unchecked_value)
      label_content = block_given? ? capture(&block) : options[:label]
      label_description = label_content || (object && object.class.human_attribute_name(name)) || name.to_s.humanize

      label_name = name
      # label's `for` attribute needs to match checkbox tag's id,
      # IE sanitized value, IE
      # https://github.com/rails/rails/blob/c57e7239a8b82957bcb07534cb7c1a3dcef71864/actionview/lib/action_view/helpers/tags/base.rb#L116-L118
      if options[:multiple]
        label_name =
          "#{name}_#{checked_value.to_s.gsub(/\s/, "_").gsub(/[^-\w]/, "").downcase}"
      end

      label_class = options[:label_class]

      if options[:custom]
        div_class = ["custom-control", "custom-checkbox"]
        div_class.append("custom-control-inline") if options[:inline]
        content_tag(:div, class: div_class.compact.join(" ")) do
          checkbox_html.concat(label(label_name, label_description, class: ["custom-control-label", label_class].compact.join(" ")))
        end
      else
        wrapper_class = "form-check"
        wrapper_class += " form-check-inline" if options[:inline]
        content_tag(:div, class: wrapper_class) do
          checkbox_html
            .concat(label(label_name,
                          label_description,
                          { class: ["form-check-label", label_class].compact.join(" ") }.merge(options[:id].present? ? { for: options[:id] } : {})))
        end
      end
    end

    bootstrap_method_alias :check_box

    # @overload radio_button(name, value, *args)
    # Generates Bootstrap markup for a radio button.
    #
    # @param name [String] Passed to the Rails helper as the name of the control
    #   and the label.
    # @param value Passed to the Rails helper as the value of the control.
    # @param args [Hash] Options processed by this method.
    #   Additional options are passed to the Rails helper as options.
    # @option args [Boolean] :custom If true, generate HTML for a custom radio
    #   button.
    # @option args [String] :help Help text to add to the HTML.
    # @option args [Boolean] :hide_label If true, hide the label and provide
    #   `sr-only` for screen readers.
    # @option args [Boolean] :inline If true, place the label on the same line
    #   as the radio button.
    # @option args [String] :label Text to use for the label.
    # @option args [String] :label_class A user-defined CSS class to add to
    #   the label element, in addition to the classes added by this method.
    # @option args [Boolean] :skip_label If true, don't generate a label tag at all.
    # @return [ActiveSupport::SafeBuffer] Bootstrap HTML for a radio button.
    def radio_button_with_bootstrap(name, value, *args)
      options = args.extract_options!.symbolize_keys!
      radio_options = options.except(:label, :label_class, :help, :inline, :custom)
      if options[:custom]
        radio_options[:class] = ["custom-control-input", options[:class]].compact.join(' ')
      else
        radio_options[:class] = ["form-check-input", options[:class]].compact.join(' ')
      end
      args << radio_options
      radio_html = radio_button_without_bootstrap(name, value, *args)

      disabled_class = " disabled" if options[:disabled]
      label_class    = options[:label_class]

      if options[:custom]
        div_class = ["custom-control", "custom-radio"]
        div_class.append("custom-control-inline") if options[:inline]
        content_tag(:div, class: div_class.compact.join(" ")) do
          radio_html.concat(label(name, options[:label], value: value, class: ["custom-control-label", label_class].compact.join(" ")))
        end
      else
        wrapper_class = "form-check"
        wrapper_class += " form-check-inline" if options[:inline]
        label_class = ["form-check-label", label_class].compact.join(" ")
        content_tag(:div, class: "#{wrapper_class}#{disabled_class}") do
          radio_html
            .concat(label(name, options[:label], { value: value, class: label_class }.merge(options[:id].present? ? { for: options[:id] } : {})))
        end
      end
    end

    bootstrap_method_alias :radio_button

    # @overload collection_check_boxes((name, collection, value, text, options = {})
    #   Generates a check box tag with Bootstrap 4 markup for each of the members of `collection`,
    #   wrapped inside a `form-group`.
    #   Unlike many of the `BootstrapForm::FormBuilder` helpers, this method does *not* call
    #   `ActionView::Helpers::FormBuilder#collection_check_boxes`.
    #   This method calls `BootstrapForm::FormBuilder#check_box` for each item in `collection`
    #   Note that, again unlike `ActionView::Helpers::FormBuilder#collection_check_boxes`,
    #   you can't give a block to this helper.
    #   A hidden field is generated before the sequence of check box tags, to ensure
    #   that a value is returned when the user doesn't check any boxes.
    #   @param name [String]
    #   @param collection [Enumerable] A collection of objects that respond to
    #     methods named `value` and `text`.
    #   @param value [Symbol, Object] If a symbol, it's used as a method name on the objects in `collection`.
    #     The method is used to determine the value of each `input` tag.
    #     If an object, and if it responds to `call`, `call` is sent to `value`
    #     with the object from `collection` as an argument.
    #   @param text [Symbol, Object] If a symbol, it's used as a method name on the objects in `collection`.
    #     The method is used to determine the `:label` option that is passed to
    #     `#check_box`.
    #     If an object, and if it responds to `call`, `call` is sent to `text`
    #     with the object from `collection` as an argument.
    #   @param options [Hash] Options that are passed to `#check_box` (TBC).
    #   @option options [String] :class A class to apply to the `<div class="form-group">`.
    #     The `:class` option is *not* passed through to `#check_box`. There is
    #     currently no way to specify a custom class on the individual check boxes.
    #   @option options [String] :control_class
    #   @option options [String] :control_col A Bootstrap 4 column class that will
    #     be applied to the TBD for the collection of check boxes.
    #   @option options [String] :help Help text for the `<div class="form-group">`.
    #   @option options [String] :hide_label If true,
    #     don't display the label for the collection of check boxes. It will still be
    #     accessible to screen readers, because the `sr-only` attribute will be added.
    #   @option options [String] :icon Obsolete. Bootstrap 4 doesn't provide icons.
    #   @option options [String] :id ID attribute for the `<div class="form-group">`.
    #   @option options [String] :label_col A Bootstrap 4 column class that will
    #     be applied to the label for the collection of check boxes.
    #   @option options [String] :label Text for a label that is output for the
    #     the collection of check boxes. If you don't want a label for the collection of
    #     check boxes, specify `:skip_label: true`.
    #     To set labels for the individual check boxes, use the `text` argument.
    #   @option options [String] :layout If `:horizontal`, the
    #     label will be placed to the left of the check box. The widths of the
    #     label and check box will be determined by the `label_col` and `control_col`
    #     options, respectively. If `inline`, the
    #     label will be placed to the left of the check box with minimal spacing.
    #   @option options [String] :skip_label If true, do not generate a label
    #     for the `<div class="form-group">`.
    #   @option options [String] :skip_required If true, don't display anything
    #     beside required fields. Without this option, `bootstrap_form` will display
    #     a red asterisk beside required fields.
    #   @option options [String] :wrapper
    #   @option options [String] :wrapper_class
    def collection_check_boxes_with_bootstrap(*args)
      html = inputs_collection(*args) do |name, value, options|
        options[:multiple] = true
        check_box(name, options, value, nil)
      end
      hidden_field(args.first,{value: "", multiple: true}).concat(html)
    end

    bootstrap_method_alias :collection_check_boxes

    # @overload collection_radio_buttons((name, collection, value, text, options = {}, html_options = {})
    #   Generates a radio button tag with Bootstrap 4 markup for each of the members of `collection`,
    #   wrapped inside a `form-group`.
    #   Unlike many of the `BootstrapForm::FormBuilder` helpers, this method does *not* call
    #   `ActionView::Helpers::FormBuilder#collection_radio_buttons`.
    #   This method calls `BootstrapForm::FormBuilder#radio` for each item in `collection`
    #   Note that, again unlike `ActionView::Helpers::FormBuilder#collection_radio_buttons`,
    #   you can't give a block to this helper.
    #   A hidden field is generated before the sequence of radio button tags, to ensure
    #   that a value is returned when the user doesn't select any buttons.
    #   @param name [String]
    #   @param collection [Enumerable] A collection of objects that respond to
    #     methods named `value` and `text`.
    #   @param value [Symbol, Object] If a symbol, it's used as a method name on the objects in `collection`.
    #     The method is used to determine the value of each `input` tag.
    #     If an object, and if it responds to `call`, `call` is sent to `value`
    #     with the object from `collection` as an argument.
    #   @param text [Symbol, Object] If a symbol, it's used as a method name on the objects in `collection`.
    #     The method is used to determine the `:label` option that is passed to
    #     `#radio`.
    #     If an object, and if it responds to `call`, `call` is sent to `text`
    #     with the object from `collection` as an argument.
    #   @param options [Hash] Options that are passed to `#radio` (TBC).
    #   @option options [String] :class A class to apply to the `<div class="form-group">`.
    #     The `:class` option is *not* passed through to `#radio`. There is
    #     currently no way to specify a custom class on the individual radio_buttons.
    #   @option options [String] :control_class
    #   @option options [String] :control_col A Bootstrap 4 column class that will
    #     be applied to the TBD for the collection of radio_buttons.
    #   @option options [String] :help Help text for the `<div class="form-group">`.
    #   @option options [String] :hide_label If true,
    #     don't display the label for the collection of radio_buttons. It will still be
    #     accessible to screen readers, because the `sr-only` attribute will be added.
    #   @option options [String] :icon Obsolete. Bootstrap 4 doesn't provide icons.
    #   @option options [String] :id ID attribute for the `<div class="form-group">`.
    #   @option options [String] :label_col A Bootstrap 4 column class that will
    #     be applied to the label for the collection of radio_buttons.
    #   @option options [String] :label Text for a label that is output for the
    #     the collection of check boxes. If you don't want a label for the collection of
    #     radio buttons, specify `:skip_label: true`.
    #     To set labels for the individual radio buttons, use the `text` argument.
    #   @option options [String] :layout If `:horizontal`, the
    #     label will be placed to the left of the radio button. The widths of the
    #     label and radio button will be determined by the `label_col` and `control_col`
    #     options, respectively. If `inline`, the
    #     label will be placed to the left of the check box with minimal spacing.
    #   @option options [String] :skip_label If true, do not generate a label
    #     for the `<div class="form-group">`.
    #   @option options [String] :skip_required If true, don't display anything
    #     beside required fields. Without this option, `bootstrap_form` will display
    #     a red asterisk beside required fields.
    #   @option options [String] :wrapper
    #   @option options [String] :wrapper_class
    #   @param html_options [Hash]
    def collection_radio_buttons_with_bootstrap(*args)
      inputs_collection(*args) do |name, value, options|
        radio_button(name, value, options)
      end
    end

    bootstrap_method_alias :collection_radio_buttons

    def form_group(*args, &block)
      options = args.extract_options!
      name = args.first

      options[:class] = ["form-group", options[:class]].compact.join(' ')
      options[:class] << " row" if get_group_layout(options[:layout]) == :horizontal
      options[:class] << " #{feedback_class}" if options[:icon]

      content_tag(:div, options.except(:id, :label, :help, :icon, :label_col, :control_col, :layout)) do
        label = generate_label(options[:id], name, options[:label], options[:label_col], options[:layout]) if options[:label]
        control = capture(&block).to_s
        control.concat(generate_help(name, options[:help]).to_s)

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
      if record_object.is_a?(Hash) && record_object.extractable_options?
        fields_options = record_object
        record_object = nil
      end
      fields_options[:layout] ||= options[:layout]
      fields_options[:label_col] = fields_options[:label_col].present? ? "#{fields_options[:label_col]}" : options[:label_col]
      fields_options[:control_col] ||= options[:control_col]
      fields_options[:inline_errors] ||= options[:inline_errors]
      fields_options[:label_errors] ||= options[:label_errors]
      fields_for_without_bootstrap(record_name, record_object, fields_options, &block)
    end

    bootstrap_method_alias :fields_for

    # the Rails `fields` method passes its options
    # to the builder, so there is no need to write a `bootstrap_form` helper
    # for the `fields` method.

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
      css_options[:class] << " is-invalid" if has_error?(method)

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

        form_group_options[:label] = {
          text: label_text,
          class: label_class,
          skip_required: options.delete(:skip_required)
        }.merge(css_options[:id].present? ? { for: css_options[:id] } : {})
      end

      form_group(method, form_group_options) do
        yield
      end
    end

    def convert_form_tag_options(method, options = {})
      unless @options[:skip_default_ids]
        options[:name] ||= method
        options[:id] ||= method
      end
      options
    end

    def generate_label(id, name, options, custom_label_col, group_layout)
      # id is the caller's options[:id] at the only place this method is called.
      # The options argument is a small subset of the options that might have
      # been passed to generate_label's caller, and definitely doesn't include
      # :id.
      options[:for] = id if acts_like_form_tag
      classes = [options[:class]]

      if get_group_layout(group_layout) == :horizontal
        classes << "col-form-label"
        classes << (custom_label_col || label_col)
      end

      unless options.delete(:skip_required)
        classes << "required" if required_attribute?(object, name)
      end

      options[:class] = classes.compact.join(" ").strip
      options.delete(:class) if options[:class].empty?

      if label_errors && has_error?(name)
        error_messages = get_error_messages(name)
        label_text = (options[:text] || object.class.human_attribute_name(name)).to_s.concat(" #{error_messages}")
        label(name, label_text, options.except(:text))
      else
        label(name, options[:text], options.except(:text))
      end
    end

    def generate_help(name, help_text)
      if has_error?(name) && inline_errors
        help_text = get_error_messages(name)
        help_klass = 'invalid-feedback'
        help_tag = :div
      end
      return if help_text == false

      help_klass ||= 'form-text text-muted'
      help_text ||= get_help_text_by_i18n_key(name)
      help_tag ||= :small

      content_tag(help_tag, help_text, class: help_klass) if help_text.present?
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
          partial_scope = object.class.model_name.name
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
        help_text ||= I18n.t("#{name}_html", scope: underscored_scope, default: '').html_safe.presence
        help_text ||= if text = I18n.t("#{name}_html", scope: downcased_scope, default: '').html_safe.presence
                        warn "I18n key '#{downcased_scope}.#{name}' is deprecated, use '#{underscored_scope}.#{name}' instead"
                        text
                      end
        help_text
      end
    end
  end
end
