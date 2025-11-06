# frozen_string_literal: true

require "rails/railtie"

module BootstrapForm
  class Engine < Rails::Engine
    config.eager_load_namespaces << BootstrapForm
    config.autoload_paths << File.expand_path("lib", __dir__)

    config.bootstrap_form = BootstrapForm.configuration
    config.bootstrap_form.default_form_attributes ||= {}

    initializer "bootstrap_form.deprecator" do |app|
      app.deprecators[:bootstrap_form] = BootstrapForm.deprecator
    end
  end
end
