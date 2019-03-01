# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module CollectionSelect
      extend ActiveSupport::Concern
      include Base

      included do
        # Disabling Metrics/ParameterLists because the upstream Rails method has the same parameters
        # rubocop:disable Metrics/ParameterLists
        def collection_select_with_bootstrap(method, collection, value_method, text_method, options={}, html_options={})
          form_group_builder(method, options, html_options) do
            input_with_error(method) do
              collection_select_without_bootstrap(method, collection, value_method, text_method, options, html_options)
            end
          end
        end
        # rubocop:enable Metrics/ParameterLists

        bootstrap_alias :collection_select
      end
    end
  end
end
