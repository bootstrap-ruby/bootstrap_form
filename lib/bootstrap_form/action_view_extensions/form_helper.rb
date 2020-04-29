# frozen_string_literal: true

module BootstrapForm
  module ActionViewExtensions
    # This module creates BootstrapForm wrappers around the default form_with
    # and form_for methods
    #
    # Example:
    #
    #   bootstrap_form_for @user do |f|
    #     f.text_field :name
    #   end
    #
    # Example:
    #
    #   bootstrap_form_with model: @user do |f|
    #     f.text_field :name
    #   end
    module FormHelper
      def bootstrap_form_for(record, options={}, &block)
        options.reverse_merge!(builder: BootstrapForm::FormBuilder)

        with_bootstrap_form_field_error_proc do
          form_for(record, options, &block)
        end
      end

      def bootstrap_form_with(options={}, &block)
        options.reverse_merge!(builder: BootstrapForm::FormBuilder)

        with_bootstrap_form_field_error_proc do
          form_with(**options, &block)
        end
      end

      def bootstrap_form_tag(options={}, &block)
        options[:acts_like_form_tag] = true

        bootstrap_form_for("", options, &block)
      end

      private

      def with_bootstrap_form_field_error_proc
        original_proc = ActionView::Base.field_error_proc
        ActionView::Base.field_error_proc = BootstrapForm.field_error_proc
        yield
      ensure
        ActionView::Base.field_error_proc = original_proc
      end
    end
  end
end

ActiveSupport.on_load(:action_view) do
  include BootstrapForm::ActionViewExtensions::FormHelper
end
