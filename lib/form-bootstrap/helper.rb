module FormBootstrap
  module Helper
    def form_bootstrap_for(object, options = {}, &block)
      options[:builder] = FormBootstrap::Builder
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
