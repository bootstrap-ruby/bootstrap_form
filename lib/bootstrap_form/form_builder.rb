require_relative 'aliasing'
require_relative 'helpers/bootstrap'

module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    extend BootstrapForm::Aliasing
    include BootstrapForm::Helpers::Bootstrap

    # @private
    attr_reader :layout, :label_col, :control_col, :has_error, :inline_errors, :label_errors, :acts_like_form_tag

    # @private
    FIELD_HELPERS = %w{color_field date_field datetime_field datetime_local_field
      email_field month_field number_field password_field phone_field
      range_field search_field telephone_field text_area text_field time_field
      url_field week_field}

    # @private
    DATE_SELECT_HELPERS = %w{date_select time_select datetime_select}

    delegate :content_tag, :capture, :concat, to: :@template

    # This is not meant to be directly called by the programmer laying out
    # a form. It's called by {BootstrapForm::Helper#bootstrap_form_for}, {BootstrapForm::Helper#bootstrap_form_tag},
    # and {BootstrapForm::Helper#bootstrap_form_with}.
    #
    # You can build on top of `bootstrap_form` if you want to extend the functionality
    # of `bootstrap_form`.
    # (This is not necessary for any of the functionality outlined in this documentation.)
    # To do so, sub-class this class,
    # calling `super` in its `initialize` method:
    # ```
    # class MyFormBuilder < BootstrapForm::FormBuilder
    #   def initialize(object_name, object, template, options)
    #     ...
    #     super
    #     ...
    #   end
    # end
    # ```
    # Then, call {BootstrapForm::Helper#bootstrap_form_for}, {BootstrapForm::Helper#bootstrap_form_tag},
    # or {BootstrapForm::Helper#bootstrap_form_with} with the `builder:` option:
    # ```
    # bootstrap_form_with(model: @user, builder: MyFormBuilder) do |f|
    # ...
    # ```
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

    # @!macro [new] append
    #   @option options [String] :append Append the string
    #     to the control, and wrap the rendered HTML in a Bootstrap
    #     `input-group` appropriately. Unless the string is HTML,
    #     the string must be wrapped in `<span class="input-group-text">...</span>`.
    #     The text wrapped in a `<span>` can be the HTML for a simple radio
    #     button or check box (see https://getbootstrap.com/docs/4.0/components/input-group/#checkboxes-and-radios).

    # @!macro [new] prepend
    #   @option options [String] :prepend Prepend the string
    #     to the control, and wrap the rendered HTML in a Bootstrap
    #     `input-group` appropriately. Unless the string is HTML,
    #     the string must be wrapped in `<span class="input-group-text">...</span>`.
    #     The text wrapped in a `<span>` can be the HTML for a simple radio
    #     button or check box (see https://getbootstrap.com/docs/4.0/components/input-group/#checkboxes-and-radios).

    # @!macro [new] return
    #   @return [ActiveSupport::SafeBuffer] Bootstrap HTML for the control,
    #     optional label, and help text and error messages, if any, wrapped in
    #     a form-group.

    # @!macro [new] textish_options
    #
    #   This method takes the same options as {text_field}.

    # @!macro [new] textish_options_minus_append_prepend
    #
    #   This method takes the same options as {collection_select_with_bootstrap #collection_select},
    #   which are the same as {text_field}, minus `:append` and `:prepend`.

    # @!macro [new] validation_errors
    #
    #   If `method` has an error, `is-invalid` is added to the control's `class`
    #   attribute. The errors are displayed according to the state of the
    #   form's `:inline_errors` and `:label_errors` options.

    # @!method color_field(method, options = {})
    # Render a `color_field` input tag using Rails' `color_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `color_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method date_field(method, options = {})
    # Render a `date_field` input tag using Rails' `date_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `date_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method datetime_field(method, options = {})
    # Render a `datetime_field` input tag using Rails' `datetime_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `datetime_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method datetime_local_field(method, options = {})
    # Render a `datetime_local_field` input tag using Rails' `datetime_local_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `datetime_local_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method email_field(method, options = {})
    # Render a `email_field` input tag using Rails' `email_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `email_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method month_field(method, options = {})
    # Render a `month_field` input tag using Rails' `month_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `month_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method number_field(method, options = {})
    # Render a `number_field` input tag using Rails' `number_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `number_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method password_field(method, options = {})
    # Render a `password_field` input tag using Rails' `password_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `password_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method phone_field(method, options = {})
    # Render a `phone_field` input tag using Rails' `phone_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `phone_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method range_field(method, options = {})
    # Render a `range_field` input tag using Rails' `range_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `range_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method search_field(method, options = {})
    # Render a `search_field` input tag using Rails' `search_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `search_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method telephone_field(method, options = {})
    # Render a `telephone_field` input tag using Rails' `telephone_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `telephone_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method text_area(method, options = {})
    # Render a `text_area` input tag using Rails' `text_area` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `text_area` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!macro [new] control_col
    #   @option options [String] :control_col ("col-sm-10") A Bootstrap 4 column
    #     class that will be applied to the control tag. Has no effect
    #     unless `layout: :horizontal` is in effect.

    # @!macro [new] help
    #   @option options [String, false] :help Help text to be rendered below the
    #     control. If no help text is specified, and if there is a translation
    #     for help text according to Rails conventions for `method` argument,
    #     the help text from the translation will automatically be rendered. To
    #     stop this text from automatically being rendered, use `help: false`.
    #     For historical reasons, the help text is not rendered if the field
    #     has an error.

    # @!macro [new] label_col
    #   @option options [String] :label_col ("col-sm-2") A Bootstrap 4 column
    #     class that will be applied to the label tag.  If no label is given,
    #     a column offset equal to `label_col` will be added on the control.
    #     Has no effect unless `layout: :horizontal` is in effect.

    # @!macro [new] common_class_to_layout
    #   @option options [String] :class Added to the `class` attribute of the
    #     `input` tag. This is the option to use if you want to add styles to an
    #     otherwise Bootstrap-styled control.
    #   @option options [String] :control_class ("form-control") If specified, it will be
    #     rendered as a class on the control tag, instead of `form-control`.
    #   @!macro control_col
    #   @!macro help
    #   @option options [Boolean] :hide_label (false) Render a `label` tag,
    #     but add the `sr-only` class to its classes. Users will not see the
    #     label, but screen readers will announce it.
    #   @option options [String, Symbol] :id If given, is rendered as the `id`
    #     attribute of the control tag, and the `for`
    #     attribute of the `label` tag. If no `:id` option is given, the Rails
    #     default IDs are rendered (which for Rails 5.1, means no IDs are rendered).
    #   @option options [String, Hash] :label Add a label before
    #     the control:
    #     - If a String: text to pass to the `text` parameter of Rails' `label` helper.
    #     - If a Hash:
    #       - `:text` gives the text to pass to the `text` parameter of Rails' `label` helper.
    #       - `:class` is added to the `class` attribute of the `label` tag
    #     - If no :label option is given, or the option is a Hash and no `:text`
    #     value is given, Rails' `label` method will generate its usual default label.
    #
    #     If the `:id` option is given, the given ID will be used
    #     as the `for` attribute of the label.
    #   @!macro label_col
    #   @option options [String] :layout Set the layout style for this field.
    #     If `layout: :inline` was specified
    #     at the form level, the results of this option at the field level are
    #     undefined.
    #     - `:horizontal`: the
    #     label will be placed to the left of the contents of the block.
    #     The widths of the label and contents of the block will be determined by
    #     the `label_col` and `control_col`
    #     options, respectively. "row" will be added to the classes on the `div` tag,
    #     along with `form-group`. The contents of the block are wrapped in a `div`
    #     with the `control_col` class applied. If no label is specified, the `div`
    #     also has an equivalent offset class applied.
    #
    #     - `:inline`: the
    #     label will be placed to the left of the control with minimal spacing.
    #     The label and control will be wrapped in a
    #     `<div class="form-group form-inline">`. (When #426 is fixed.)
    #
    #     - `:default`: Use the "default" Bootstrap 4 layout: Labels above controls,
    #     and label and control expand to occupy the full width of their container
    #
    #     - not specified: Use the `layout` specified at the form level

    # @!macro [new] common_skip
    #   @option options [Boolean] :skip_label (false) If true, do not render a
    #     label tag at all. If horizontal layout is in effect, add an offset
    #     class to the control, equal to the width the label would have occupied.
    #   @option options [Boolean] :skip_required (false) If false, add `required` to the
    #     label's `class` attribute. If true, don't add `required` to the label's
    #     `class` attribute. If you want an asterisk beside the label of
    #     required fields, add the following to your CSS:
    #     ```
    #     label.required:after {
    #       content:" *";
    #     }
    #     ```

    # @!macro [new] common_wrapper
    #   @option options [Hash] :wrapper Options to be passed to the wrapper.
    #     see {#form_group} for a description of these options.
    #   @option options [String] :wrapper_class A class or classes to be added
    #     to the `class` attribute of the wrapper. This is a short form for:
    #     `wrapper: { class: "additional-class" }`.


    # @!method text_field(method, options = {})
    # Render a `text_field` input tag using Rails' `text_field` helper,
    # augmented with Bootstrap 4 markup as described below,
    # and wrapped in a `<div class="form-group">`.
    # `method` is passed as the `method` parameter to Rails' `text_field` helper.
    # @!macro validation_errors
    # @param method [Object] passed to the `method` parameter of Rails' `text_field` helper.
    # @param options [Hash] Options affecting how the control and other
    #   tags are rendered. Anything in `options` not listed below is passed to
    #   the Rails helper.
    # @!macro append
    # @!macro common_class_to_layout
    # @!macro prepend
    # @!macro common_skip
    # @!macro common_wrapper
    # @!macro return

    # @!method time_field(method, options = {})
    # Render a `time_field` input tag using Rails' `time_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `time_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method url_field(method, options = {})
    # Render a `url_field` input tag using Rails' `url_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `url_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method week_field(method, options = {})
    # Render a `week_field` input tag using Rails' `week_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `week_field` helper.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    FIELD_HELPERS.each do |method_name|
      with_method_name = "#{method_name}_with_bootstrap"
      without_method_name = "#{method_name}_without_bootstrap"

      define_method(with_method_name) do |name, options = {}|
        form_group_builder(name, options) do
          send(without_method_name, name, options)
        end
      end

      bootstrap_method_alias method_name
    end

    # @!method date_select(method, options = {}, html_options = {})
    # Calls the Rails `date_select` helper. The form group wrapper `div`
    # has `rails-bootstrap-forms-date-select` added to its classes.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method datetime_select(method, options = {}, html_options = {})
    # Calls the Rails `datetime_select` helper. The form group wrapper `div`
    # has `rails-bootstrap-forms-datetime-select` added to its classes.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    # @!method time_select(method, options = {}, html_options = {})
    # Calls the Rails `time_select` helper. The form group wrapper `div`
    # has `rails-bootstrap-forms-time-select` added to its classes.
    # @!macro validation_errors
    # @!macro textish_options
    # @!macro return

    DATE_SELECT_HELPERS.each do |method_name|
      with_method_name = "#{method_name}_with_bootstrap"
      without_method_name = "#{method_name}_without_bootstrap"

      define_method(with_method_name) do |name, options = {}, html_options = {}|
        prevent_prepend_and_append!(options)
        form_group_builder(name, options, html_options) do
          content_tag(:div, send(without_method_name, name, options, html_options), class: control_specific_class(method_name))
        end
      end

      bootstrap_method_alias method_name
    end

    # @overload file_field(name, options = {})
    # Render a `file_field` input tag using Rails' `file_field` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `file_field` helper.
    # This method ignores the `:control_class` option, if given. It applies the
    # `form-control-file` class to the `input` tag.
    # @!macro validation_errors
    # @!macro textish_options_minus_append_prepend
    # @!macro return
    def file_field_with_bootstrap(name, options = {})
      prevent_prepend_and_append!(options)
      options = options.reverse_merge(control_class: "custom-file-input")
      form_group_builder(name, options) do
        content_tag(:div, class: "custom-file") do
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

    bootstrap_method_alias :file_field

    # @overload select(method, choices = nil, options = {}, html_options = {}, &block)
    # Render a `select` tag and `option` tags using Rails' `select` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `select` helper.
    # @!macro validation_errors
    # @param method [Object] Passed as the `method` parameter of Rails' `select` method.
    # @param choices [Enumerable] Passed as the `choices` parameter of Rails' `select` method.
    # @!macro textish_options
    # @param html_options [Hash] Combined with the `options` hash. Any
    #   `html_options` not listed under the `options` parameter are passed to
    #   the `options` parameter of Rails' `select` helper.
    # @!macro return
    def select_with_bootstrap(method, choices = nil, options = {}, html_options = {}, &block)
      form_group_builder(method, options, html_options) do
        select_without_bootstrap(method, choices, options, html_options, &block)
      end
    end

    bootstrap_method_alias :select

    # @overload collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    # Render a `collection_select` input tag using Rails' `collection_select` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `collection_select` helper.
    # @!macro validation_errors
    # @param method [Symbol] Passed to the `method` parameter of Rails' `colleciton_select'
    # @param collection [Enumerable]  Passed to the `collection` parameter of Rails' `colleciton_select'
    # @param value_method [Symbol] Passed to the `value_method` parameter of Rails' `colleciton_select'
    # @param text_method [Symbol] Passed to the `text_method` parameter of Rails' `colleciton_select'
    # @param options [Hash] Options affecting how the control and other
    #   tags are rendered. Anything in 'options' not listed below is passed to
    #   the Rails helper. These are the same options with the same meaning as
    #   those for {text_field}, minus `:append` and `:prepend`.
    # @!macro common_class_to_layout
    # @!macro common_skip
    # @!macro common_wrapper
    # @param html_options [Hash] Passed to the `html_options` parameter of Rails' `colleciton_select'
    # @!macro return
    def collection_select_with_bootstrap(method, collection, value_method, text_method, options = {}, html_options = {})
      prevent_prepend_and_append!(options)
      form_group_builder(method, options, html_options) do
        collection_select_without_bootstrap(method, collection, value_method, text_method, options, html_options)
      end
    end

    bootstrap_method_alias :collection_select

    # @overload grouped_collection_select(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
    # Render a `grouped_collection_select` input tag using Rails' `grouped_collection_select` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `grouped_collection_select` helper.
    # @!macro validation_errors
    # @param method [Symbol] Passed to the `method` parameter of Rails' `colleciton_select'
    # @param collection [Enumerable]  Passed to the `collection` parameter of Rails' `colleciton_select'
    # @param group_method [Symbol] Passed to the `group_method` parameter of Rails' `colleciton_select'
    # @param group_label_method [Symbol] Passed to the `group_label_method` parameter of Rails' `colleciton_select'
    # @param option_key_method [Symbol] Passed to the `option_key_method` parameter of Rails' `colleciton_select'
    # @param option_value_method [Symbol] Passed to the `option_value_method` parameter of Rails' `colleciton_select'
    # @!macro textish_options_minus_append_prepend
    # @param html_options [Hash] Passed to the `html_options` parameter of Rails' `colleciton_select'
    # @!macro return
    def grouped_collection_select_with_bootstrap(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
      prevent_prepend_and_append!(options)
      form_group_builder(method, options, html_options) do
        grouped_collection_select_without_bootstrap(method, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
      end
    end

    bootstrap_method_alias :grouped_collection_select

    # @overload time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
    # Render a `time_zone_select` input tag using Rails' `time_zone_select` helper,
    # augmented with Bootstrap 4 markup as described below.
    # `method` is passed as the `method` parameter to Rails' `time_zone_select` helper.
    # @!macro validation_errors
    # @!macro textish_options_minus_append_prepend
    # @!macro return
    def time_zone_select_with_bootstrap(method, priority_zones = nil, options = {}, html_options = {})
      prevent_prepend_and_append!(options)
      form_group_builder(method, options, html_options) do
        time_zone_select_without_bootstrap(method, priority_zones, options, html_options)
      end
    end

    bootstrap_method_alias :time_zone_select

    # @!macro [new] check_and_radio_inline
    #   @option options [Boolean] :inline If true, mark up the label and control
    #     so they look good when rendered in an in-line form. If `layout: :inline`
    #     was specified at the form level, use the same markup as if `inline: true`
    #     was specified. If `layout: :inline` was specified at the form level,
    #     specifying `inline: false` gives undefined results.

    # @!macro [new] check_box_options
    #   @param options [Hash] Options processed by this method.
    #     Additional options are passed to the Rails helper as options.
    #   @option options [Boolean] :custom If true, generate HTML for a custom check
    #     box.
    #   @option options [String] :help Help text to add to the HTML.
    #   @option options [Boolean] :hide_label If true, hide the label and and mark it
    #     `sr-only` for screen readers.
    #   @!macro check_and_radio_inline
    #   @option options [String] :label Text to use for the label.
    #   @option options [String] :label_class A user-defined CSS class to add to
    #     the label element, in addition to the classes added by this method.
    #   @option options [Boolean] :skip_label If true, don't generate a label tag at all.
    #   @return [ActiveSupport::SafeBuffer] Bootstrap HTML for a check box

    # @overload check_box(name, options = {}, checked_value = "1", unchecked_value = "0", &block)
    # Generate Bootstrap markup for a check box, with a label to the right
    # of the check box.
    # @param name [Object] Passed to the `method` parameter of Rails' `check_box`.
    # @param checked_value [Object] Passed to the `checked_value` parameter of Rails' `check_box`.
    # @param unchecked_value [Object] Passed to the `unchecked_value` parameter of Rails' `check_box`.
    # @!macro check_box_options
    # @yield The value of the block, if any, is used as the label. If the `label`
    #   option is also given, the value of the block will be used.
    def check_box_with_bootstrap(name, options = {}, checked_value = "1", unchecked_value = "0", &block)
      prevent_prepend_and_append!(options)
      options = options.symbolize_keys!
      check_box_options = options.except(:label, :label_class, :help, :inline, :custom, :hide_label, :skip_label)
      check_box_classes = [check_box_options[:class]]
      check_box_classes << "position-static" if options[:skip_label] || options[:hide_label]
      if options[:custom]
        validation = nil
        validation = "is-invalid" if has_error?(name)
        check_box_options[:class] = (["custom-control-input", validation] + check_box_classes).compact.join(' ')
      else
        check_box_options[:class] = (["form-check-input"] + check_box_classes).compact.join(' ')
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

      label_classes = [options[:label_class]]
      label_classes << hide_class if options[:hide_label]

      if options[:custom]
        div_class = ["custom-control", "custom-checkbox"]
        div_class.append("custom-control-inline") if layout_inline?(options[:inline])
        label_class = label_classes.prepend("custom-control-label").compact.join(" ")
        content_tag(:div, class: div_class.compact.join(" ")) do
          if options[:skip_label]
            checkbox_html
          else
            # TODO: Notice we don't seem to pass the ID into the custom control.
            checkbox_html.concat(label(label_name, label_description, class: label_class))
          end
        end
      else
        wrapper_class = "form-check"
        wrapper_class += " form-check-inline" if layout_inline?(options[:inline])
        label_class = label_classes.prepend("form-check-label").compact.join(" ")
        content_tag(:div, class: wrapper_class) do
          if options[:skip_label]
            checkbox_html
          else
            checkbox_html
              .concat(label(label_name,
                            label_description,
                            { class: label_class }.merge(options[:id].present? ? { for: options[:id] } : {})))
          end
        end
      end
    end

    bootstrap_method_alias :check_box

    # @overload radio_button(name, value, *args)
    # Renders Bootstrap markup for a radio button, with a label to the right
    # of the radio button.
    #
    # @param name [String] Passed to the Rails helper as the name of the control
    #   and the label.
    # @param value [#to_s] Passed to the Rails helper as the value of the control.
    # @param args [Hash] Options processed by this method.
    #   Additional options are passed to the Rails helper as options.
    # @option args [Boolean] :custom If true, generate HTML for a custom radio
    #   button.
    # @option args [String] :help Help text to add to the HTML.
    # @option args [Boolean] :hide_label If true, hide the label and provide
    #   `sr-only` for screen readers.
    # @!macro check_and_radio_inline
    # @option args [String] :label Text to use for the label.
    # @option args [String] :label_class A user-defined CSS class to add to
    #   the label element, in addition to the classes added by this method.
    # @option args [Boolean] :skip_label If true, don't generate a label tag at all.
    # @return [ActiveSupport::SafeBuffer] Bootstrap HTML for a radio button.
    def radio_button_with_bootstrap(name, value, *args)
      prevent_prepend_and_append!(options)
      options = args.extract_options!.symbolize_keys!
      radio_options = options.except(:label, :label_class, :help, :inline, :custom, :hide_label, :skip_label)
      radio_classes = [options[:class]]
      radio_classes << "position-static" if options[:skip_label] || options[:hide_label]
      if options[:custom]
        radio_options[:class] = radio_classes.prepend("custom-control-input").compact.join(' ')
      else
        radio_options[:class] = radio_classes.prepend("form-check-input").compact.join(' ')
      end
      args << radio_options
      radio_html = radio_button_without_bootstrap(name, value, *args)

      disabled_class = " disabled" if options[:disabled]
      label_classes  = [options[:label_class]]
      label_classes << hide_class if options[:hide_label]

      if options[:custom]
        div_class = ["custom-control", "custom-radio"]
        div_class.append("custom-control-inline") if layout_inline?(options[:inline])
        label_class = label_classes.prepend("custom-control-label").compact.join(" ")
        content_tag(:div, class: div_class.compact.join(" ")) do
          if options[:skip_label]
            radio_html
          else
            # TODO: Notice we don't seem to pass the ID into the custom control.
            radio_html.concat(label(name, options[:label], value: value, class: label_class))
          end
        end
      else
        wrapper_class = "form-check"
        wrapper_class += " form-check-inline" if layout_inline?(options[:inline])
        label_class = label_classes.prepend("form-check-label").compact.join(" ")
        content_tag(:div, class: "#{wrapper_class}#{disabled_class}") do
          if options[:skip_label]
            radio_html
          else
            radio_html
              .concat(label(name, options[:label], { value: value, class: label_class }.merge(options[:id].present? ? { for: options[:id] } : {})))
          end
        end
      end
    end

    bootstrap_method_alias :radio_button

    # @!macro [new] collection_check_radio_args
    #   @param name [String]
    #   @param collection [Enumerable] A collection of objects.
    #   @param value [Symbol, Proc, Lambda] If a symbol, it's used as a method name on
    #     the objects in `collection`, to obtain the value for the `input` tag.
    #     If an Proc or Lambda, it's called with the object from `collection` as
    #     its argument, to obtain the value for the `input` tag.
    #   @param text [Symbol, Proc, Lambda] If a symbol, it's used as a method
    #     on the objects in `collection`, to obtain the text for the label of
    #     the `input` tag.
    #     If Proc or Lambda, it's called
    #     with the object from `collection` as its argument, to obtain the text
    #     for the label of the `input` tag.

    # @!macro [new] collection_check_radio_options
    #   @param options [Hash]
    #   @option options [String] :class A class to apply to the `<div class="form-group">`.
    #     The `:class` option is *not* passed through to the control. There is
    #     currently no way to specify a custom class on the individual control.
    #   @option options [String] :control_class
    #   @option options [String] :control_col A Bootstrap 4 column class that will
    #     be applied to the label for the collection of controls.
    #   @option options [String] :help Help text for the `<div class="form-group">`.
    #   @option options [String] :hide_label If true,
    #     don't display the label for the collection of controls. It will still be
    #     accessible to screen readers, because the `sr-only` attribute will be added.
    #   @option options [String] :icon Obsolete. Bootstrap 4 doesn't provide icons.
    #   @option options [String] :id ID attribute for the `<div class="form-group">`.

    # @!macro [new] collection_check_radio_options_b
    #   @option options [String] :label_col A Bootstrap 4 column class that will
    #     be applied to the label for the collection of controls.
    #   @option options [String] :label Text for a label that is output for the
    #     the collection of controls. If you don't want a label for the collection of
    #     controls, specify `:skip_label: true`.
    #     To set labels for the individual controls, use the `text` argument.
    #   @option options [String] :layout If `:horizontal`, the
    #     label will be placed to the left of the controls. The widths of the
    #     label and group of controls will be determined by the `label_col` and
    #     `control_col` options, respectively. If `inline`, the
    #     label will be placed to the left of the group of controls with minimal
    #     spacing.

    # @overload collection_check_boxes(name, collection, value, text, options = {})
    #   Renders a check box tag with Bootstrap 4 markup for each of the members of `collection`,
    #   wrapped inside a `form-group`, and with a label before the group of radio buttons.
    #   Unlike many of the `BootstrapForm::FormBuilder` helpers, this method does *not* call
    #   `ActionView::Helpers::FormBuilder#collection_check_boxes`.
    #   This method calls `BootstrapForm::FormBuilder#check_box` for each item in `collection`
    #   Note that, again unlike `ActionView::Helpers::FormBuilder#collection_check_boxes`,
    #   you can't give a block to this helper.
    #   A hidden field is generated before the sequence of check box tags, to ensure
    #   that a value is returned when the user doesn't check any boxes.
    #   @!macro collection_check_radio_args
    #   @!macro collection_check_radio_options
    #   @!macro check_and_radio_inline
    #   @!macro collection_check_radio_options_b
    #   @!macro common_skip
    #   @!macro common_wrapper
    def collection_check_boxes_with_bootstrap(*args)
      prevent_prepend_and_append!(options)
      html = inputs_collection(*args) do |name, value, options|
        options[:multiple] = true
        check_box(name, options, value, nil)
      end
      hidden_field(args.first,{value: "", multiple: true}).concat(html)
    end

    bootstrap_method_alias :collection_check_boxes

    # @overload collection_radio_buttons(name, collection, value, text, options = {}, html_options = {})
    #   Renders a radio button tag with Bootstrap 4 markup for each of the members of `collection`,
    #   wrapped inside a `form-group`, and with a label before the group of radio buttons.
    #   Unlike many of the `BootstrapForm::FormBuilder` helpers, this method does *not* call
    #   `ActionView::Helpers::FormBuilder#collection_radio_buttons`.
    #   This method calls `BootstrapForm::FormBuilder#radio` for each item in `collection`
    #   Note that, again unlike `ActionView::Helpers::FormBuilder#collection_radio_buttons`,
    #   you can't give a block to this helper.
    #   A hidden field is generated before the sequence of radio button tags, to ensure
    #   that a value is returned when the user doesn't select any buttons.
    #   @!macro collection_check_radio_args
    #   @!macro collection_check_radio_options
    #   @!macro check_and_radio_inline
    #   @!macro collection_check_radio_options_b
    #   @!macro common_skip
    #   @!macro common_wrapper
    #   @param html_options [Hash] Options to be passed to
    def collection_radio_buttons_with_bootstrap(*args)
      prevent_prepend_and_append!(options)
      inputs_collection(*args) do |name, value, options|
        radio_button(name, value, options)
      end
    end

    bootstrap_method_alias :collection_radio_buttons

    # @overload form_group(method, options = {}, &block)
    #   Wrap whatever the block renders in a `div` tag with class `form-group`.
    #   Renders a label if and only if the `:label` option is explicitly given.
    #
    #   If `method` is an object that has an error, and the form's
    #   `:inline_errors` is true, the error is displayed after the contents of
    #   the block.
    #   @param method [Object]
    #   @param options [Hash] Options affecting how the control and other
    #     tags are rendered.
    #   @option options [String] :class Added to the `class` attribute of the `div` tag,
    #     along with `form-group`.
    #   @!macro control_col
    #   @!macro help
    #   @option options [String, Symbol] :id If given, is rendered as the `for`
    #     attribute of the `label` tag
    #   @option options [String] :label The text to use for a label, which is placed
    #     before the contents of the block. If no `:label` option is given,
    #     no `label` tag is rendered.
    #     If the `:id` option is given, the given ID will be used
    #     as the `for` attribute of the label.
    #   @!macro label_col
    #   @option options [String] :layout Set the layout style for this control.
    #     If `layout: :inline` was specified
    #     at the form level, the results of this option at the field level are
    #     undefined.
    #     - `:horizontal`: the
    #     label will be placed to the left of the contents of the block.
    #     The widths of the label and contents of the block will be determined by
    #     the `label_col` and `control_col`
    #     options, respectively. "row" will be added to the classes on the `div` tag,
    #     along with `form-group`. The contents of the block are wrapped in a `div`
    #     with the `control_col` class applied. If no label is specified, the `div`
    #     also has an equivalent offset class applied.
    #
    #     - `:inline`: the
    #     label will be placed to the left of the contents of the block with minimal spacing.
    #     The label and contents of the block will be wrapped in a
    #     `<div class="form-group form-inline">`. (When #426 is fixed.)
    #
    #     - `:default`: Use the "default" Bootstrap 4 layout: Labels above contents of the block,
    #     and label and contents of the block expand to occupy the full width of their container
    #
    #     - not specified: Use the `layout` specified at the form level
    # @!macro return
    def form_group(*args, &block)
      options = args.extract_options!
      name = args.first

      options[:class] = ["form-group", options[:class]].compact.join(' ')
      options[:class] << " row" if get_group_layout(options[:layout]) == :horizontal
      options[:class] << " form-inline" if field_inline_override?(options[:layout])
      options[:class] << " #{feedback_class}" if options[:icon]

      content_tag(:div, options.except(:append, :id, :label, :help, :icon, :input_group_class, :label_col, :control_col, :layout, :prepend)) do
        label = generate_label(options[:id], name, options[:label], options[:label_col], options[:layout]) if options[:label]
        control = prepend_and_append_input(name, options, &block).to_s

        if get_group_layout(options[:layout]) == :horizontal
          control_class = options[:control_col] || control_col
          unless options[:label]
            control_offset = offset_col(options[:label_col] || @label_col)
            control_class = "#{control_class} #{control_offset}"
          end
          control = content_tag(:div, control, class: control_class)
        end

        help = options[:help]

        help_text = generate_help(name, help).to_s

        concat(label).concat(control).concat(help_text)
      end
    end

    # @overload fields_for(record_name, record_object = nil, fields_options = {}, &block)
    # Calls Rails' `fields_for`.
    # @param fields_options [Hash] Options to be passed to Rails' `fields_for`.
    # @option fields_options [Symbol] :control_col (The value specified for the form)
    #   A Bootstrap 4 column-width class
    #   (e.g. `col-sm-9`) that will be applied to all label fields in the form,
    #   if, and only if, `layout: :horizontal` is specified.
    #   The form-level `control_col` can can be overridden by specifying `control_col`
    #   on an individual field helper.
    # @option fields_options [Symbol] :inline_errors (The value specified for the form)
    #   If false, validation errors will
    #   not be displayed below the field to which they correspond. if
    #   true, display errors below the field to which they correspond.
    # @option fields_options [Symbol] :label_col (The value specified for the form)
    #   A Bootstrap 4 column-width class
    #   (e.g. `col-sm-3`) that will be applied to all label fields in the form,
    #   if, and only if, `layout: :horizontal` is specified.
    # @option fields_options [Symbol] :label_errors (The value specified for the form)
    #   If true, validation errors will be
    #   displayed as part of the label, and not below the field to which they
    #   correspond. To display errors both in the label and below the field,
    #   specify `label_errors: true` and `inline_errors: true`.
    # @option fields_options [Symbol] :layout (The value specified for the form)
    #   Specify the layout style for the scope of the `fields_for`.
    #   - `:inline`: `form-inline` is added
    #   to the form's classes. This will generate fields that appear on a single
    #   line, with `label` tags on the same line as their corresponding `input`
    #   tags, and minimal spacing
    #   between elements. It's intended for things like a search form in a
    #   menu bar.
    #
    #   - `:horizontal`: `label` tags will be placed to the left of their
    #   corresponding `input` tag, rather than above. The fields can be arranged
    #   into rows and columns using Bootstrap 4 markup generated outside the
    #   `bootstrap_form` helpers (e.g. in the view templates). The
    #   `col-form-label` class is applied to all labels.
    #
    #   - The default is the Bootstrap 4 default: Labels above inputs, and inputs
    #   expand to fill their container.
    # @return [BootstrapForm::FormBuilder]
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
      label_col.sub(/^col-(\w+)-(\d)$/, 'offset-\1-\2')
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

      form_group_options[:append] = options.delete(:append) if options[:append]
      form_group_options[:prepend] = options.delete(:prepend) if options[:prepend]
      form_group_options[:input_group_class] = options.delete(:input_group_class) if options[:input_group_class]

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
