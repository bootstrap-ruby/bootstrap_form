# frozen_string_literal: true

module BootstrapForm
  module Components
    module Hints
      extend ActiveSupport::Concern

      private

      # Help text gets an id so the control can reference it with
      # aria-describedby, as the Bootstrap documentation recommends.
      def generate_help(name, help_text, id: nil)
        text = help_text_for(name, help_text)
        content_tag(:small, text, class: "form-text", id: aria_help_id(id:, name:)) if text.present?
      end

      def help_text_for(name, help_text)
        return if help_text == false

        help_text || get_help_text_by_i18n_key(name)
      end

      def aria_help_id(name:, id: nil)
        id.present? ? "#{id}_help" : field_id(name, :help)
      end

      # The ids of the help text and error feedback that describe a control.
      def aria_describedby(name, options)
        ids = []
        ids << aria_help_id(id: options[:id], name:) if help_text_for(name, options[:help]).present?
        ids << feedback_id(options, name) if error?(name)
        ids.join(" ").presence
      end

      def get_help_text_by_i18n_key(name)
        return unless object

        partial_scope = if object_class.respond_to?(:model_name)
                          object_class.model_name.name
                        else
                          object_class.name
                        end

        # First check for a subkey :html, as it is also accepted by i18n, and the
        # simple check for name would return an hash instead of a string (both
        # with .presence returning true!)
        help_text = nil
        ["#{name}.html", name, "#{name}_html"].each do |scope|
          break if help_text

          help_text = scoped_help_text(scope, partial_scope)
        end
        help_text
      end

      def object_class
        if !object.class.is_a?(ActiveModel::Naming) &&
           object.respond_to?(:klass) && object.klass.is_a?(ActiveModel::Naming)
          object.klass
        else
          object.class
        end
      end

      def scoped_help_text(name, partial_scope)
        underscored_scope = "activerecord.help.#{partial_scope.underscore}"
        downcased_scope = "activerecord.help.#{partial_scope.downcase}"

        help_text = translated_help_text(name, underscored_scope).presence

        help_text ||= if (text = translated_help_text(name, downcased_scope).presence)
                        warn "I18n key '#{downcased_scope}.#{name}' is deprecated, use '#{underscored_scope}.#{name}' instead"
                        text
                      end

        help_text
      end

      def translated_help_text(name, scope)
        ActiveSupport::SafeBuffer.new I18n.t(name, scope: scope, default: "")
      end
    end
  end
end
