# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module TextArea
      extend ActiveSupport::Concern
      include Base

      included do
        bootstrap_field :text_area
        alias_method :textarea_with_bootstrap, :text_area_with_bootstrap if Rails::VERSION::MAJOR >= 8
        bootstrap_field :textarea if Rails::VERSION::MAJOR >= 8
      end
    end
  end
end
