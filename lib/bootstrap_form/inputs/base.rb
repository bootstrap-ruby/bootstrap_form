# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module Base
      extend ActiveSupport::Concern

      class_methods do
        def bootstrap_field(field_name)
          define_method "#{field_name}_with_bootstrap" do |name, options={}|
            form_group_builder(name, options) do
              prepend_and_append_input(name, options) do
                send("#{field_name}_without_bootstrap".to_sym, name, options)
              end
            end
          end

          bootstrap_alias field_name
        end

        def bootstrap_select_group(field_name)
          with_field_name = "#{field_name}_with_bootstrap"
          without_field_name = "#{field_name}_without_bootstrap"
          define_method(with_field_name) do |name, options={}, html_options={}|
            form_group_builder(name, options, html_options) do
              form_group_content_tag(name, field_name, without_field_name, options, html_options)
            end
          end

          bootstrap_alias field_name
        end

        def bootstrap_alias(field_name)
          alias_method "#{field_name}_without_bootstrap".to_sym, field_name
          alias_method field_name, "#{field_name}_with_bootstrap".to_sym
        end
      end
    end
  end
end
