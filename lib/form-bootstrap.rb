require 'form-bootstrap/builder'
require 'form-bootstrap/helper'

module FormBootstrap
end

ActionView::Helpers::FormHelper.send :include, FormBootstrap::Helper
