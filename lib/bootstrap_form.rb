# frozen_string_literal: true

require "action_view"
require "action_pack"
require "bootstrap_form/action_view_extensions/form_helper"
require "bootstrap_form/configuration"

module BootstrapForm
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Configuration
    autoload :FormBuilder
    autoload :FormGroupBuilder
    autoload :FormGroup
    autoload :Components
    autoload :Inputs
    autoload :Helpers
  end

  class << self
    def eager_load!
      super
      BootstrapForm::Components.eager_load!
      BootstrapForm::Helpers.eager_load!
      BootstrapForm::Inputs.eager_load!
    end

    def config
      @config ||= BootstrapForm::Configuration.new
    end

    def configure
      yield config
    end

    def deprecator
      @deprecator ||= ActiveSupport::Deprecation.new("a future release", "BootstrapForm")
    end
  end

  mattr_accessor :field_error_proc
  # rubocop:disable Style/ClassVars
  @@field_error_proc = proc do |html_tag, _instance_tag|
    html_tag
  end
  # rubocop:enable Style/ClassVars
end

require "bootstrap_form/engine" if defined?(Rails)
