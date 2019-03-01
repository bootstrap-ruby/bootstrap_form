# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module EmailField
      extend ActiveSupport::Concern
      include Base

      included do
        bootstrap_field :email_field
      end
    end
  end
end
