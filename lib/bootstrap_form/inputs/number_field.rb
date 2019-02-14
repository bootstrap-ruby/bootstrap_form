# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module NumberField
      extend ActiveSupport::Concern
      include Base

      included do
        bootstrap_field :number_field
      end
    end
  end
end
