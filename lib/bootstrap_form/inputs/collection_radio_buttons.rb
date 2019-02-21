# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module CollectionRadioButtons
      extend ActiveSupport::Concern
      include Base
      include InputsCollection

      included do
        def collection_radio_buttons_with_bootstrap(*args)
          inputs_collection(*args) do |name, value, options|
            radio_button(name, value, options)
          end
        end

        bootstrap_alias :collection_radio_buttons
      end
    end
  end
end
