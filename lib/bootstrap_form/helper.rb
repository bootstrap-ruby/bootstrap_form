require_relative 'helpers/nested_form'

module BootstrapForm
  module Helper
    include ::BootstrapForm::Helpers::NestedForm

    def bootstrap_form_for(object, options = {}, &block)
      options.reverse_merge!(builder: BootstrapForm::FormBuilder)

      options = process_options(options)

      temporarily_disable_field_error_proc do
        form_for(object, options, &block)
      end
    end

    def bootstrap_form_tag(options = {}, &block)
      options[:acts_like_form_tag] = true

      bootstrap_form_for('', options, &block)
    end

    def bootstrap_form_with(model: nil, scope: nil, url: nil, format: nil, **options, &block)
      options.reverse_merge!(builder: BootstrapForm::FormBuilderFormWith)
      # options[:acts_like_form_tag] = true if model.nil?

      options = process_options(options)

      temporarily_disable_field_error_proc do
        form_with(model: model, scope: scope, url: url, format: format, **options, &block)
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
      ActionView::Base.field_error_proc = proc { |input, _instance| input }
      yield
    ensure
      ActionView::Base.field_error_proc = original_proc
    end
  end
end
