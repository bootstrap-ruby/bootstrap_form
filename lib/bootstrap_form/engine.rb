# frozen_string_literal: true

require "rails/railtie"

module BootstrapForm
  class Engine < Rails::Engine
    config.eager_load_namespaces << BootstrapForm
    config.autoload_paths << File.expand_path("lib", __dir__)
  end
end
