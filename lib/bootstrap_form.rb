require 'bootstrap_form/form_builder'
require 'bootstrap_form/helper'

module BootstrapForm
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end

ActionView::Base.send :include, BootstrapForm::Helper
