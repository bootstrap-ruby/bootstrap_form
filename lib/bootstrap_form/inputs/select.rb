# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module Select
      extend ActiveSupport::Concern
      include Base

      included do
        def select_with_bootstrap(method, choices=nil, options={}, html_options={}, &block)
          html_options = html_options.reverse_merge(control_class: "form-select")
          form_group_builder(method, options, html_options) do
            prepend_and_append_input(method, options) do
              select_without_bootstrap(method, choices, options, html_options, &block)
            end
          end
        end

        bootstrap_alias :select
      end
    end
  end
end
