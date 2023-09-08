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

        if Rails::VERSION::MAJOR < 7
          def field_name(method, *methods, multiple: false, index: @options[:index])
            object_name = @options.fetch(:as) { @object_name }

            @template.field_name(object_name, method, *methods, index: index, multiple: multiple)
          end
        end
      end
    end
  end
end
