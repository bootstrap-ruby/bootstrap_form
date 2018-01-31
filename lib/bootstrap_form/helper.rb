module BootstrapForm
  module Helper

    # @!macro [new] form_options
    #   @option options [Symbol] :layout If `:inline`, `form-inline` is added
    #     to the form's classes. This will generate a form that appears on a single
    #     line, with `label` tags on the same line as their corresponding `input`
    #     tags, and minimal spacing
    #     between elements. It's intended for things like a search form in a
    #     menu bar.
    #
    #     If `:horizontal`, `label` tags will be placed to the left of their
    #     corresponding `input` tag, rather than above. The form can be arranged
    #     into rows and columns using Bootstrap 4 markup generated outside the
    #     `bootstrap_form` helpers (e.g. in the view templates).
    #
    #     The default is the Bootstrap 4 default: Labels above inputs, and inputs
    #     expand to fill their container.
    #   @option options [String] :label_col A Bootstrap 4 column-width class
    #     (e.g. `col-sm-3`) that will be applied to all label fields in the form.
    #     The form-level `label_col` can can be overridden by specifying `label_col`
    #     on an individual field helper. Default: `col-sm-2`.
    #   @option options [String] :control_col A Bootstrap 4 column-width class
    #     (e.g. `col-sm-9`) that will be applied to all label fields in the form.
    #     The form-level `control_col` can can be overridden by specifying `control_col`
    #     on an individual field helper. Default: `col-sm-10`.
    #   @option options [Boolean] :inline_errors If false, validation errors will
    #     not be displayed below the field to which they correspond. Default is to
    #     display errors below the field to which they correspond.
    #   @option options [Boolean] :label_errors If true, validation errors will be
    #     displayed as part of the label, and not below the field to which they
    #     correspond. To display errors both in the label and below the field,
    #     specify `label_errors: true` and `inline_errors: true`.


    # Use Bootstrap 4 markup for a form. The generated `form` tag will have
    # a `role="form"` added to it. Also, the default Rails field error (validation)
    # handling is disabled for the form, because `bootstrap_form` provides its own,
    # Bootstrap 4-friendly, error handling.
    # @param object [Object] Passed to `form_for` as the first parameter.
    # @param options [Hash] Hash of options. Options not listed below
    #   are passed to `form_for`.
    # @!macro form_options
    def bootstrap_form_for(object, options = {}, &block)
      options.reverse_merge!({builder: BootstrapForm::FormBuilder})

      options = process_options(options)

      temporarily_disable_field_error_proc do
        form_for(object, options, &block)
      end
    end

    # {include:bootstrap_form_for}
    # @param options [Hash] Hash of options. Options not listed below
    #   are passed to `form_tag`.
    # @!macro form_options
    def bootstrap_form_tag(options = {}, &block)
      options[:acts_like_form_tag] = true

      bootstrap_form_for("", options, &block)
    end

    # {include:bootstrap_form_for}
    # @param options [Hash] Hash of options. Options not listed below
    #   are passed to `form_with`.
    # @!macro form_options
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

    def temporarily_disable_field_error_proc
      original_proc = ActionView::Base.field_error_proc
      ActionView::Base.field_error_proc = proc { |input, instance| input }
      yield
    ensure
      ActionView::Base.field_error_proc = original_proc
    end
  end
end
