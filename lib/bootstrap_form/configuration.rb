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
          Please use Rails.application.config.bootstrap_form.default_form_attributes= instead.
        MESSAGE
        @default_form_attributes = attributes
        Rails.application.config.bootstrap_form.default_form_attributes = attributes
      else
        raise ArgumentError, "Unsupported default_form_attributes #{attributes.inspect}"
      end
    end

    def default_form_attributes
      BootstrapForm.deprecator.warn(<<~MESSAGE.squish)
        BootstrapForm::Configuration#default_form_attributes will be removed in a future release.
        Please use Rails.application.config.bootstrap_form.default_form_attributes instead.
      MESSAGE
      Rails.application.config.bootstrap_form.default_form_attributes
    end
  end

  mattr_accessor :configuration, default: nil

  class << self
    def configure
      yield(configuration) if block_given?
    end
  end
end
