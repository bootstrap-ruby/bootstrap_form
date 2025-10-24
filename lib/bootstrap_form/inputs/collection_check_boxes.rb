# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module CollectionCheckBoxes
      extend ActiveSupport::Concern
      include Base
      include InputsCollection

      included do
        def collection_check_boxes_with_bootstrap(*args)
          html = inputs_collection(*args) do |name, value, options|
            options[:multiple] = true
            check_box(name, options, value, nil)
          end

          if args.extract_options!.symbolize_keys!.delete(:include_hidden) { true }
            html.prepend hidden_field(args.first, value: "", name: field_name(args[0], multiple: true))
          end
          html
        end

        bootstrap_alias :collection_check_boxes
        alias_method :collection_checkboxes_with_bootstrap, :collection_check_boxes_with_bootstrap if Rails::VERSION::MAJOR >= 8
        bootstrap_alias :collection_checkboxes if Rails::VERSION::MAJOR >= 8
      end
    end
  end
end
