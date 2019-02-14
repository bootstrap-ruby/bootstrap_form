# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module RangeField
      extend ActiveSupport::Concern
      include Base

      included do
        bootstrap_field :range_field
      end
    end
  end
end
