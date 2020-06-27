# frozen_string_literal: true

module BootstrapForm
  class Configuration
    def default_form_attributes=(attributes)
      case attributes
      when nil
        @default_form_attributes = {}
      when Hash
        @default_form_attributes = attributes
      else
        raise ArgumentError, "Unsupported default_form_attributes #{attributes.inspect}"
      end
    end

    def default_form_attributes
      return @default_form_attributes if defined? @default_form_attributes

      {}
    end
  end
end
