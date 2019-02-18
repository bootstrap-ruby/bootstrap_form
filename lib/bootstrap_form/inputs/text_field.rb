# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module TextField
      extend ActiveSupport::Concern
      include Base

      included do
        bootstrap_field :text_field
      end
    end
  end
end
