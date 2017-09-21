require 'bootstrap_form/form_builder'
require 'bootstrap_form/helper'

module BootstrapForm
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end

ActiveSupport.on_load(:action_view) do
  include BootstrapForm::Helper
end
