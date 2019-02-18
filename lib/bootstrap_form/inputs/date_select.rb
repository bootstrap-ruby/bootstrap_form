# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module DateSelect
      extend ActiveSupport::Concern
      include Base

      included do
        bootstrap_select_group :date_select
      end
    end
  end
end
