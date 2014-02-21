begin
  require 'nested_form/builder_mixin'

  module BootstrapForm
    class NestedFormBuilder < ::BootstrapForm::FormBuilder
      include ::NestedForm::BuilderMixin
    end
  end

  module BootstrapForm
    module Helpers
      module NestedForm
        def bootstrap_nested_form_for(object, options = {}, &block)
          options.reverse_merge!({builder: BootstrapForm::NestedFormBuilder})
          bootstrap_form_for(object, options) do |f|
            capture(f, &block).to_s << after_nested_form_callbacks
          end
        end
      end
    end
  end

rescue LoadError
  module BootstrapForm
    module Helpers
      module NestedForm
        def bootstrap_nested_form_for(object, options = {}, &block)
          raise 'nested_forms was not found. Is it in your Gemfile?'
        end
      end
    end
  end
end
