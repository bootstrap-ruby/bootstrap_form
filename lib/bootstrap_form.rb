require 'bootstrap_form/form_builder'
require 'bootstrap_form/helper'

module BootstrapForm
end

ActionView::Base.send :include, BootstrapForm::Helper
