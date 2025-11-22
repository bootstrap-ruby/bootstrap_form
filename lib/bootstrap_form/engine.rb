# frozen_string_literal: true

require "rails/railtie"

module BootstrapForm
  class Engine < Rails::Engine
    config.eager_load_namespaces << BootstrapForm
    config.autoload_paths << File.expand_path("lib", __dir__)

    config.bootstrap_form = BootstrapForm.config
    config.bootstrap_form.default_form_attributes ||= {}
    if config.bootstrap_form.fieldset_around_collections.nil?
      config.bootstrap_form.fieldset_around_collections = Rails.env.development?
    end

    initializer "bootstrap_form.configure" do |app|
      BootstrapForm.config = app.config.bootstrap_form
    end

    initializer "bootstrap_form.deprecator" do |app|
      app.deprecators[:bootstrap_form] = BootstrapForm.deprecator
    end
  end
end
