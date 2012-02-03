module BootstrapForm
  module Helper
    def bootstrap_form_for(object, options = {}, &block)
      options[:builder] = BootstrapForm::FormBuilder

      # add .form-vertical class if it's not horizontal
      options[:html] = {} unless options.has_key?(:html)
      css = options[:html].fetch(:class, '')
      options[:html][:class] = "#{css} form-vertical" unless css.match /horizontal/

      temporarily_disable_field_error_proc do
        form_for(object, options, &block)
      end
    end

    def temporarily_disable_field_error_proc
      original_proc = ActionView::Base.field_error_proc
      ActionView::Base.field_error_proc = proc { |input, instance| input }
      yield
    ensure
      ActionView::Base.field_error_proc = original_proc
    end
  end
end
