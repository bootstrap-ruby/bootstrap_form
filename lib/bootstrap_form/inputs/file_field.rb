# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module FileField
      extend ActiveSupport::Concern
      include Base

      included do
        def file_field_with_bootstrap(name, options={})
          options = options.reverse_merge(control_class: "form-control")
          form_group_builder(name, options) do
            input_with_error(name) do
              file_field_without_bootstrap(name, options)
            end
          end
        end

        bootstrap_alias :file_field
      end
    end
  end
end
