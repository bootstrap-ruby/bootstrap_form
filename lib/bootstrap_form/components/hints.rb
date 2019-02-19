# frozen_string_literal: true

module BootstrapForm
  module Components
    module Hints
      extend ActiveSupport::Concern

      private

      def generate_help(name, help_text)
        return if help_text == false || inline_error?(name)

        help_klass ||= "form-text text-muted"
        help_text ||= get_help_text_by_i18n_key(name)
        help_tag ||= :small

        content_tag(help_tag, help_text, class: help_klass) if help_text.present?
      end

      def get_help_text_by_i18n_key(name)
        return unless object

        partial_scope = if object.class.respond_to?(:model_name)
                          object.class.model_name.name
                        else
                          object.class.name
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
