# frozen_string_literal: true

module BootstrapForm
  module Components
    module Validation
      extend ActiveSupport::Concern

      # Options that control validation feedback without being HTML attributes.
      FEEDBACK_OPTIONS = %i[invalid_feedback valid_feedback tooltip valid].freeze

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

      def generate_error(name, id, feedback_id: nil, tooltip: false)
        return unless inline_error?(name)

        content_tag(:div, get_error_messages(name), class: validation_feedback_class("invalid", tooltip:),
                                                    id: feedback_id || aria_feedback_id(id:, name:))
      end

      # The model's error feedback, or else the static `invalid_feedback`
      # message for browser validation, followed by any `valid_feedback`.
      # `tooltip: true` renders both as Bootstrap's tooltip-style feedback.
      def generate_feedback(name, options, error: true)
        tooltip = options[:tooltip]
        invalid = (generate_error(name, options[:id], feedback_id: options[:feedback_id], tooltip:) if error)
        invalid ||= static_feedback(options[:invalid_feedback], "invalid", tooltip:)
        valid = static_feedback(options[:valid_feedback], "valid", tooltip:)
        safe_join([invalid, valid].compact).presence
      end

      def static_feedback(text, state, tooltip:)
        tag.div(text, class: validation_feedback_class(state, tooltip:)) if text
      end

      def validation_feedback_class(state, tooltip:)
        tooltip ? "tooltip #{state}-tooltip" : "#{state}-feedback"
      end

      # The feedback id can be set explicitly, e.g. by a collection whose
      # inputs share one feedback element named after the group's id.
      def feedback_id(options, name)
        options[:feedback_id] || aria_feedback_id(id: options[:id], name:)
      end

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

      def aria_feedback_id(name:, id: nil)
        id.present? ? "#{id}_feedback" : field_id(name, :feedback)
      end
    end
  end
end
