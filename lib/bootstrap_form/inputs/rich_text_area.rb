# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module RichTextArea
      extend ActiveSupport::Concern
      include Base

      included do
        def rich_text_area_with_bootstrap(name, options={})
          form_group_builder(name, options) do
            prepend_and_append_input(name, options) do
              options[:class] = ["trix-content", options[:class]].compact.join(" ")
              rich_text_area_without_bootstrap(name, options)
            end
          end
        end

        bootstrap_alias :rich_text_area
      end
    end
  end
end
