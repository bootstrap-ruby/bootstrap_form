require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "bootstrap_form"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    if config.respond_to?(:load_defaults)
      config.load_defaults [Rails::VERSION::MAJOR, Rails::VERSION::MINOR].join(".")
    end

    if config.respond_to?(:secret_key_base)
      config.secret_key_base = "ignore"
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
