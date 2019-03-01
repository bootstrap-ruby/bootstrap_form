# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module FileField
      extend ActiveSupport::Concern
      include Base

      included do
        def file_field_with_bootstrap(name, options={})
          options = options.reverse_merge(control_class: "custom-file-input")
          form_group_builder(name, options) do
            content_tag(:div, class: "custom-file") do
              input_with_error(name) do
                file_field_input(name, options)
              end
            end
          end
        end

        bootstrap_alias :file_field
      end

      private

      def file_field_input(name, options)
        placeholder = options.delete(:placeholder) || "Choose file"
        placeholder_opts = { class: "custom-file-label" }
        placeholder_opts[:for] = options[:id] if options[:id].present?

        file_field_without_bootstrap(name, options) + label(name, placeholder, placeholder_opts)
      end
    end
  end
end
