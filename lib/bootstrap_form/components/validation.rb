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

        presence_validators?(target, obj, attribute) || required_association?(target, obj, attribute)
      end

      def required_association?(target, object, attribute)
        target.try(:reflections)&.any? do |name, a|
          next unless a.is_a?(ActiveRecord::Reflection::BelongsToReflection)
          next unless a.foreign_key == attribute.to_s

          presence_validators?(target, object, name)
        end
      end

      def presence_validators?(target, object, attribute)
        target.validators_on(attribute).select { |v| presence_validator?(v.class) }.any? do |validator|
          if_option = validator.options[:if]
          unless_opt = validator.options[:unless]
          (!if_option || call_with_self(object, if_option)) && (!unless_opt || !call_with_self(object, unless_opt))
        end
      end

      def call_with_self(object, proc)
        proc = object.method(proc) if proc.is_a? Symbol
        object.instance_exec(*[(object if proc.arity >= 1)].compact, &proc)
      end

      def presence_validator?(validator_class)
        validator_class == ActiveModel::Validations::PresenceValidator ||
          (defined?(ActiveRecord::Validations::PresenceValidator) &&
            validator_class == ActiveRecord::Validations::PresenceValidator)
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

      # rubocop:disable Metrics/AbcSize
      def get_error_messages(name)
        object.class.try(:reflections)&.each do |association_name, a|
          next unless a.is_a?(ActiveRecord::Reflection::BelongsToReflection)
          next unless a.foreign_key == name.to_s

          object.errors[association_name].each do |error|
            object.errors.add(name, error)
          end
        end

        safe_join(object.errors[name], ", ")
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
