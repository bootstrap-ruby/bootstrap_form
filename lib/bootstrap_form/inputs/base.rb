# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module Base
      extend ActiveSupport::Concern

      class_methods do
        def bootstrap_field(field_name)
          define_method :"#{field_name}_with_bootstrap" do |name, options={}|
            warn_deprecated_layout_value(options)
            options = options.reverse_merge(control_class: "form-range") if field_name == :range_field
            options = options.reverse_merge(control_class: "form-control form-control-color") if field_name == :color_field
            form_group_builder(name, options) do
              prepend_and_append_input(name, options) do
                options[:placeholder] ||= name if options[:floating]
                send(:"#{field_name}_without_bootstrap", name, options.except(:floating))
              end
            end
          end

          bootstrap_alias field_name
        end

        def bootstrap_select_group(field_name)
          define_method(:"#{field_name}_with_bootstrap") do |name, options={}, html_options={}|
            html_options = html_options.reverse_merge(control_class: "form-select")
            form_group_builder(name, options, html_options) do
              form_group_content_tag(name, field_name, "#{field_name}_without_bootstrap", options, html_options)
            end
          end

          bootstrap_alias field_name
        end

        # Creates the methods *_without_bootstrap and *_with_bootstrap.
        #
        # If your application did not include the rails gem for one of the dsl
        # methods, then a name error is raised and suppressed. This can happen
        # if your application does not include the actiontext dependency due to
        # `rich_text_area` not being defined.
        def bootstrap_alias(field_name)
          alias_method :"#{field_name}_without_bootstrap", field_name
          alias_method field_name, :"#{field_name}_with_bootstrap"
        rescue NameError # rubocop:disable Lint/SuppressedException
        end
      end

      private

      def warn_deprecated_layout_value(options)
        return unless options[:layout] == :default

        warn "Layout `:default` is deprecated, use `:vertical` instead."
        options[:layout] = :vertical
      end
    end
  end
end
