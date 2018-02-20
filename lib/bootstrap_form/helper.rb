module BootstrapForm
  module Helper

    # @!macro [new] form_options
    #   @option options [String] :control_col ("col-sm-10")
    #     A Bootstrap 4 column-width class
    #     (e.g. `col-sm-9`) that will be applied to all label fields in the form,
    #     if, and only if, `layout: :horizontal` is specified.
    #     The form-level `control_col` can can be overridden by specifying `control_col`
    #     on an individual field helper.
    #   @option options [Boolean] :inline_errors (true)
    #     If false, validation errors will
    #     not be displayed below the field to which they correspond. if
    #     true, display errors below the field to which they correspond.
    #     This option can only be set at the form level.
    #   @option options [String] :label_col ("col-sm-2")
    #     A Bootstrap 4 column-width class
    #     (e.g. `col-sm-3`) that will be applied to all label fields in the form,
    #     if, and only if, `layout: :horizontal` is specified.
    #     The form-level `label_col` can can be overridden by specifying `label_col`
    #     on an individual field helper.
    #   @option options [Boolean] :label_errors (false)
    #     If true, validation errors will be
    #     displayed as part of the label, and not below the field to which they
    #     correspond. To display errors both in the label and below the field,
    #     specify `label_errors: true` and `inline_errors: true`.
    #     This option can only be set at the form level.
    #   @option options [Symbol] :layout Specify the layout style for the whole form.
    #     - `:horizontal`: `label` tags will be placed to the left of their
    #     corresponding control, rather than above. The widths of the label and
    #     control will be determined by the `label_col` and `control_col`
    #     options, respectively.  The `col-form-label`
    #     class is applied to all labels. Each label and control will be wrapped
    #     in a `<div class="form-group row">` (except for `radio_button` and
    #     `check_box`). Note that `row` is added to the `div`'s classes.
    #
    #     - `:inline`: `form-inline` is added
    #     to the form's classes. This will generate a form that appears on a single
    #     line, with `label` tags on the same line as their corresponding `input`
    #     tags, and minimal spacing
    #     between elements. It's intended for things like a search form in a
    #     menu bar.
    #
    #     - The default is the Bootstrap 4 default: Labels above inputs, and inputs
    #     expand to fill their container.

    # @!macro [new] form_call
    #   Use Bootstrap 4 markup for a form. The generated `form` tag will have
    #   a `role="form"` added to it. Also, the default Rails field error (validation)
    #   handling is disabled for the form, because `$0` provides its own,
    #   Bootstrap 4-friendly, error handling.

    # @!macro form_call
    # @param object [Object] Passed to `form_for` as the first parameter.
    # @param options [Hash] Hash of options. Options not listed below
    #   are passed to `form_for`.
    # @!macro form_options
    # @return [BootstrapForm::FormBuilder]
    def bootstrap_form_for(object, options = {}, &block)
      options.reverse_merge!({builder: BootstrapForm::FormBuilder})

      options = process_options(options)

      temporarily_disable_field_error_proc do
        form_for(object, options, &block)
      end
    end

    # @!macro form_call
    # @param options [Hash] Hash of options. Options not listed below
    #   are passed to `form_tag`.
    # @!macro form_options
    # @return [BootstrapForm::FormBuilder]
    def bootstrap_form_tag(options = {}, &block)
      options[:acts_like_form_tag] = true

      bootstrap_form_for("", options, &block)
    end

    # @!macro form_call
    # @param options [Hash] Hash of options. Options not listed below
    #   are passed to `form_with`.
    # @!macro form_options
    # @return [BootstrapForm::FormBuilder]
    def bootstrap_form_with(options = {}, &block)
      options.reverse_merge!(builder: BootstrapForm::FormBuilder)

      options = process_options(options)

      temporarily_disable_field_error_proc do
        form_with(options, &block)
      end
    end

    private

    def process_options(options)
      options[:html] ||= {}
      options[:html][:role] ||= 'form'

      if options[:layout] == :inline
        options[:html][:class] = [options[:html][:class], 'form-inline'].compact.join(' ')
      end

      options
    end

    public

    # @private
    def temporarily_disable_field_error_proc
      original_proc = ActionView::Base.field_error_proc
      ActionView::Base.field_error_proc = proc { |input, instance| input }
      yield
    ensure
      ActionView::Base.field_error_proc = original_proc
    end
  end
end
