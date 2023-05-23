# frozen_string_literal: true

module BootstrapForm
  module Components
    module Validation
      extend ActiveSupport::Concern

      private

      def error?(name)
        name && object.respond_to?(:errors) && (object.errors[name].any? || association_error?(name))
      end

      def association_error?(name)
        object.class.try(:reflections)&.any? do |association_name, a|
          next unless a.is_a?(ActiveRecord::Reflection::BelongsToReflection)
          next unless a.foreign_key == name.to_s

          object.errors[association_name].any?
        end
      end

      def required_attribute?(obj, attribute)
        return false unless obj && attribute

        target = obj.instance_of?(Class) ? obj : obj.class
        return false unless target.respond_to? :validators_on

        presence_validator?(target_unconditional_validators(target, attribute)) ||
          required_association?(target, attribute)
      end

      def required_association?(target, attribute)
        target.try(:reflections)&.find do |name, a|
          next unless a.is_a?(ActiveRecord::Reflection::BelongsToReflection)
          next unless a.foreign_key == attribute.to_s

          presence_validator?(target_unconditional_validators(target, name))
        end
      end

      def target_unconditional_validators(target, attribute)
        target.validators_on(attribute)
              .reject { |validator| validator.options[:if].present? || validator.options[:unless].present? }
              .map(&:class)
      end

      def presence_validator?(target_validators)
        target_validators.include?(ActiveModel::Validations::PresenceValidator) ||
          (defined?(ActiveRecord::Validations::PresenceValidator) &&
            target_validators.include?(ActiveRecord::Validations::PresenceValidator))
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
        object.class.try(:reflections)&.each do |association_name, a|
          next unless a.is_a?(ActiveRecord::Reflection::BelongsToReflection)
          next unless a.foreign_key == name.to_s

          messages << object.errors[association_name]
        end
        messages.join(", ")
      end
    end
  end
end
