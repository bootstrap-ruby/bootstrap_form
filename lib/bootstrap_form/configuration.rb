# frozen_string_literal: true

module BootstrapForm
  class Configuration
    def default_form_attributes=(attributes)
      case attributes
      when nil
        @default_form_attributes = {}
      when Hash
        BootstrapForm.deprecator.warn(<<~MESSAGE.squish)
          BootstrapForm::Configuration#default_form_attributes= will be removed in a future release.
          Please use BootstrapForm.config.default_form_attributes= instead.
        MESSAGE
        @default_form_attributes = attributes
        BootstrapForm.config.default_form_attributes = attributes
      else
        raise ArgumentError, "Unsupported default_form_attributes #{attributes.inspect}"
      end
    end

    def default_form_attributes
      BootstrapForm.deprecator.warn(<<~MESSAGE.squish)
        BootstrapForm::Configuration#default_form_attributes will be removed in a future release.
        Please use BootstrapForm.config.default_form_attributes instead.
      MESSAGE
      BootstrapForm.config.default_form_attributes
    end
  end

  mattr_accessor :config, default: ActiveSupport::OrderedOptions.new

  class << self
    def configure
      yield(config) if block_given?
    end
  end
end
