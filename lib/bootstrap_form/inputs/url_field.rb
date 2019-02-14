# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module UrlField
      extend ActiveSupport::Concern
      include Base

      included do
        bootstrap_field :url_field
      end
    end
  end
end
