# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module TimeSelect
      extend ActiveSupport::Concern
      include Base

      included do
        bootstrap_select_group :time_select
      end
    end
  end
end
