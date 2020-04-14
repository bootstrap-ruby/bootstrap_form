# frozen_string_literal: true

module BootstrapForm
  class Configuration
    DEFAULT = {
      default_form_attributes: {
        role: "form"
      }
    }.freeze

    DEFAULT.keys.each { |key| attr_accessor key }

    def initialize
      DEFAULT.each { |key, value| send("#{key}=", value) }
    end
  end
end
