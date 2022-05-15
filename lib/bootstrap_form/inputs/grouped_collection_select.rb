# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module GroupedCollectionSelect
      extend ActiveSupport::Concern
      include Base

      included do
        # Disabling Metrics/ParameterLists because the upstream Rails method has the same parameters
        # rubocop:disable Metrics/ParameterLists
        def grouped_collection_select_with_bootstrap(method, collection, group_method,
                                                     group_label_method, option_key_method,
                                                     option_value_method, options={}, html_options={})
          html_options = html_options.reverse_merge(control_class: "form-select")
          form_group_builder(method, options, html_options) do
            prepend_and_append_input(method, options) do
              grouped_collection_select_without_bootstrap(method, collection, group_method,
                                                          group_label_method, option_key_method,
                                                          option_value_method, options, html_options)
            end
          end
        end
        # rubocop:enable Metrics/ParameterLists

        bootstrap_alias :grouped_collection_select
      end
    end
  end
end
