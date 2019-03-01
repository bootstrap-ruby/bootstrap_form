# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module SearchField
      extend ActiveSupport::Concern
      include Base

      included do
        bootstrap_field :search_field
      end
    end
  end
end
