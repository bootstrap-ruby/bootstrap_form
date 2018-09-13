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
          prepend_and_append_input(name, options) do
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
          html_class = control_specific_class(method_name)
          if @layout == :horizontal && !options[:skip_inline].present?
            html_class = "#{html_class} form-inline"
          end
          content_tag(:div, class: html_class) do
            input_with_error(name) do
              send(without_method_name, name, options, html_options)
            end
          end
        end
      end

      bootstrap_method_alias method_name
    end

    def file_field_with_bootstrap(name, options = {})
      options = options.reverse_merge(control_class: "custom-file-input")
      form_group_builder(name, options) do
        content_tag(:div, class: "custom-file") do
          input_with_error(name) do
            placeholder = options.delete(:placeholder) || "Choose file"
            placeholder_opts = { class: "custom-file-label" }
            placeholder_opts[:for] = options[:id] if options[:id].present?

            input = file_field_without_bootstrap(name, options)
            placeholder_label = label(name, placeholder, placeholder_opts)
            concat(input)
            concat(placeholder_label)
          end
        end
      end
    end

    bootstrap_method_alias :file_field

    def select_with_bootstrap(method, choices = nil, options = {}, html_options = {}, &block)
      form_group_builder(method, options, html_options) do
        prepend_and_append_input(method, options) do
          select_without_bootstrap(method, choices, options, html_options, &block)
        end
      end
    end

    bootstrap_method_alias :select

    def collection_select_with_bootstrap(method, collection, value_method, text_method, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        input_with_error(method) do
          collection_select_without_bootstrap(method, collection, value_method, text_method, options, html_options)
        end
      end
    end

    bootstrap_method_alias :collection_select

    def grouped_collection_select_with_bootstrap(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        input_with_error(method) do
          grouped_collection_select_without_bootstrap(method, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
        end
      end
    end

    bootstrap_method_alias :grouped_collection_select

    def time_zone_select_with_bootstrap(method, priority_zones = nil, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        input_with_error(method) do
          time_zone_select_without_bootstrap(method, priority_zones, options, html_options)
        end
      end
    end

    bootstrap_method_alias :time_zone_select

    def check_box_with_bootstrap(name, options = {}, checked_value = "1", unchecked_value = "0", &block)
      options = options.symbolize_keys!
      check_box_options = options.except(:label, :label_class, :error_message, :help, :inline, :custom, :hide_label, :skip_label, :wrapper_class)
      check_box_classes = [check_box_options[:class]]
      check_box_classes << "position-static" if options[:skip_label] || options[:hide_label]
      check_box_classes << "is-invalid" if has_error?(name)

      label_classes = [options[:label_class]]
      label_classes << hide_class if options[:hide_label]

      if options[:custom]
        check_box_options[:class] = (["custom-control-input"] + check_box_classes).compact.join(' ')
        wrapper_class = ["custom-control", "custom-checkbox"]
        wrapper_class.append("custom-control-inline") if layout_inline?(options[:inline])
        label_class = label_classes.prepend("custom-control-label").compact.join(" ")
      else
        check_box_options[:class] = (["form-check-input"] + check_box_classes).compact.join(' ')
        wrapper_class = ["form-check"]
        wrapper_class.append("form-check-inline") if layout_inline?(options[:inline])
        label_class = label_classes.prepend("form-check-label").compact.join(" ")
      end

      checkbox_html = check_box_without_bootstrap(name, check_box_options, checked_value, unchecked_value)
      label_content = block_given? ? capture(&block) : options[:label]
      label_description = label_content || (object && object.class.human_attribute_name(name)) || name.to_s.humanize

      label_name = name
      # label's `for` attribute needs to match checkbox tag's id,
      # IE sanitized value, IE
      # https://github.com/rails/rails/blob/5-0-stable/actionview/lib/action_view/helpers/tags/base.rb#L123-L125
      if options[:multiple]
        label_name =
          "#{name}_#{checked_value.to_s.gsub(/\s/, "_").gsub(/[^-[[:word:]]]/, "").mb_chars.downcase.to_s}"
      end

      label_options = { class: label_class }
      label_options[:for] = options[:id] if options[:id].present?

      wrapper_class.append(options[:wrapper_class]) if options[:wrapper_class]

      content_tag(:div, class: wrapper_class.compact.join(" ")) do
        html = if options[:skip_label]
          checkbox_html
        else
          checkbox_html.concat(label(label_name, label_description, label_options))
        end
        html.concat(generate_error(name)) if options[:error_message]
        html
      end
    end

    bootstrap_method_alias :check_box

    def radio_button_with_bootstrap(name, value, *args)
      options = args.extract_options!.symbolize_keys!
      radio_options = options.except(:label, :label_class, :error_message, :help, :inline, :custom, :hide_label, :skip_label, :wrapper_class)
      radio_classes = [options[:class]]
      radio_classes << "position-static" if options[:skip_label] || options[:hide_label]
      radio_classes << "is-invalid" if has_error?(name)

      label_classes  = [options[:label_class]]
      label_classes << hide_class if options[:hide_label]

      if options[:custom]
        radio_options[:class] = radio_classes.prepend("custom-control-input").compact.join(' ')
        wrapper_class = ["custom-control", "custom-radio"]
        wrapper_class.append("custom-control-inline") if layout_inline?(options[:inline])
        label_class = label_classes.prepend("custom-control-label").compact.join(" ")
      else
        radio_options[:class] = radio_classes.prepend("form-check-input").compact.join(' ')
        wrapper_class = ["form-check"]
        wrapper_class.append("form-check-inline") if layout_inline?(options[:inline])
        wrapper_class.append("disabled") if options[:disabled]
        label_class = label_classes.prepend("form-check-label").compact.join(" ")
      end
      radio_html = radio_button_without_bootstrap(name, value, radio_options)

      label_options = { value: value, class: label_class }
      label_options[:for] = options[:id] if options[:id].present?

      wrapper_class.append(options[:wrapper_class]) if options[:wrapper_class]

      content_tag(:div, class: wrapper_class.compact.join(" ")) do
        html = if options[:skip_label]
          radio_html
        else
          radio_html.concat(label(name, options[:label], label_options))
        end
        html.concat(generate_error(name)) if options[:error_message]
        html
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

    def form_group(*args, &block)
      options = args.extract_options!
      name = args.first

      options[:class] = ["form-group", options[:class]].compact.join(' ')
      options[:class] << " row" if get_group_layout(options[:layout]) == :horizontal &&
                                   !options[:class].split.include?("form-row")
      options[:class] << " form-inline" if field_inline_override?(options[:layout])
      options[:class] << " #{feedback_class}" if options[:icon]

      content_tag(:div, options.except(:append, :id, :label, :help, :icon, :input_group_class, :label_col, :control_col, :layout, :prepend)) do
        label = generate_label(options[:id], name, options[:label], options[:label_col], options[:layout]) if options[:label]
        control = capture(&block)

        help = options[:help]
        help_text = generate_help(name, help).to_s

        if get_group_layout(options[:layout]) == :horizontal
          control_class = options[:control_col] || control_col
          unless options[:label]
            control_offset = offset_col(options[:label_col] || @label_col)
            control_class = "#{control_class} #{control_offset}"
          end
          control = content_tag(:div, control + help_text, class: control_class)
          concat(label).concat(control)
        else
          concat(label).concat(control).concat(help_text)
        end
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

    def layout_default?(field_layout = nil)
      [:default, nil].include? layout_in_effect(field_layout)
    end

    def layout_horizontal?(field_layout = nil)
      layout_in_effect(field_layout) == :horizontal
    end

    def layout_inline?(field_layout = nil)
      layout_in_effect(field_layout) == :inline
    end

    def field_inline_override?(field_layout = nil)
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

      wrapper_class = options.delete(:wrapper_class)
      wrapper_options = options.delete(:wrapper)

      html_options.symbolize_keys! if html_options

      # Add control_class; allow it to be overridden by :control_class option
      css_options = html_options || options
      control_classes = css_options.delete(:control_class) { control_class }
      css_options[:class] = [control_classes, css_options[:class]].compact.join(" ")
      css_options[:class] << " is-invalid" if has_error?(method)

      options = convert_form_tag_options(method, options) if acts_like_form_tag

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
        label_class = hide_class if options.delete(:hide_label) || options[:label_as_placeholder]

        if options[:label].is_a?(String)
          label_text ||= options.delete(:label)
        end

        form_group_options[:label] = {
          text: label_text,
          class: label_class,
          skip_required: options.delete(:skip_required)
        }.merge(css_options[:id].present? ? { for: css_options[:id] } : {})

        if options.delete(:label_as_placeholder)
          css_options[:placeholder] = label_text || object.class.human_attribute_name(method)
        end
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

      if layout_horizontal?(group_layout)
        classes << "col-form-label"
        classes << (custom_label_col || label_col)
      elsif layout_inline?(group_layout)
        classes << "mr-sm-2"
      end

      unless options.delete(:skip_required)
        classes << "required" if required_attribute?(object, name)
      end

      options[:class] = classes.compact.join(" ").strip
      options.delete(:class) if options[:class].empty?

      if label_errors && has_error?(name)
        error_messages = get_error_messages(name)
        label_text = (options[:text] || object.class.human_attribute_name(name)).to_s.concat(" #{error_messages}")
        options[:class] = [options[:class], "text-danger"].compact.join(" ")
        label(name, label_text, options.except(:text))
      else
        label(name, options[:text], options.except(:text))
      end
    end

    def has_inline_error?(name)
      has_error?(name) && inline_errors
    end

    def generate_error(name)
      if has_inline_error?(name)
        help_text = get_error_messages(name)
        help_klass = 'invalid-feedback'
        help_tag = :div

        content_tag(help_tag, help_text, class: help_klass)
      end
    end

    def generate_help(name, help_text)
      return if help_text == false || has_inline_error?(name)

      help_klass ||= 'form-text text-muted'
      help_text ||= get_help_text_by_i18n_key(name)
      help_tag ||= :small

      content_tag(help_tag, help_text, class: help_klass) if help_text.present?
    end

    def get_error_messages(name)
      object.errors[name].join(", ")
    end

    def inputs_collection(name, collection, value, text, options = {}, &block)
      options[:inline] ||= layout_inline?(options[:layout])
      form_group_builder(name, options) do
        inputs = ""

        collection.each_with_index do |obj, i|
          input_options = options.merge(label: text.respond_to?(:call) ? text.call(obj) : obj.send(text))

          input_value = value.respond_to?(:call) ? value.call(obj) : obj.send(value)
          if checked = input_options[:checked]
            input_options[:checked] = checked == input_value                     ||
                                      Array(checked).try(:include?, input_value) ||
                                      checked == obj                             ||
                                      Array(checked).try(:include?, obj)
          end

          input_options.delete(:class)
          inputs << block.call(name, input_value, input_options.merge(error_message: i == collection.size - 1))
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
        # First check for a subkey :html, as it is also accepted by i18n, and the simple check for name would return an hash instead of a string (both with .presence returning true!)
        help_text = I18n.t("#{name}.html", scope: underscored_scope, default: '').html_safe.presence
        help_text ||= if text = I18n.t("#{name}.html", scope: downcased_scope, default: '').html_safe.presence
                        warn "I18n key '#{downcased_scope}.#{name}' is deprecated, use '#{underscored_scope}.#{name}' instead"
                        text
                      end
        help_text ||= I18n.t(name, scope: underscored_scope, default: '').presence
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
