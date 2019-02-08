# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module TextField
      extend ActiveSupport::Concern

      included do
        def text_field_with_bootstrap(name, options = {})
          form_group_builder(name, options) do
            prepend_and_append_input(name, options) do
              send(:text_field_without_bootstrap, name, options)
            end
          end
        end

        bootstrap_method_alias :text_field
      end
    end
  end
end
