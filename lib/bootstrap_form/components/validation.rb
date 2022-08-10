# frozen_string_literal: true

module BootstrapForm
  module Components
    module Validation
      extend ActiveSupport::Concern

      private

      def error?(name)
        name && object.respond_to?(:errors) &&
          (object.errors[name].any? || (name.end_with?("_id") && object.errors[name[0..-4]].any?))
      end

      def required_attribute?(obj, attribute)
        return false unless obj && attribute

        target = obj.instance_of?(Class) ? obj : obj.class
        return false unless target.respond_to? :validators_on

        presence_validator?(target_validators(target, attribute))
      end

      def target_validators(target, attribute)
        target_validators = target.validators_on(attribute).map(&:class)
        target_validators.concat target.validators_on(attribute[0..-4]).map(&:class) if attribute.end_with?("_id")
        target_validators
      end

      def presence_validator?(target_validators)
        has_presence_validator = target_validators.include?(
          ActiveModel::Validations::PresenceValidator
        )

        if defined? ActiveRecord::Validations::PresenceValidator
          has_presence_validator |= target_validators.include?(
            ActiveRecord::Validations::PresenceValidator
          )
        end

        has_presence_validator
      end

      def inline_error?(name)
        error?(name) && inline_errors
      end

      def generate_error(name)
        return unless inline_error?(name)

        help_text = get_error_messages(name)
        help_klass = "invalid-feedback"
        help_tag = :div

        content_tag(help_tag, help_text, class: help_klass)
      end

      def get_error_messages(name)
        messages = object.errors[name]
        messages.concat object.errors[name[0..-4]] if name.end_with?("_id")
        messages.join(", ")
      end
    end
  end
end
