# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module Submit
      def button(value=nil, options={}, &)
        value = setup_css_class "btn btn-secondary", value, options
        super
      end

      def submit(value=nil, options={})
        value = setup_css_class "btn btn-secondary", value, options
        layout == :inline ? form_group { super } : super
      end

      def primary(value=nil, options={}, &block)
        value = setup_css_class "btn btn-primary", value, options

        if options[:render_as_button] || options[:data][:turbo_submits_with] || block
          options.except! :render_as_button
          button(value, options, &block)
        else
          submit(value, options)
        end
      end

      private

      def setup_css_class(the_class, value, options)
        if value.is_a?(Hash)
          options.merge!(value)
          value = nil
        end
        unless options.key? :class
          if (extra_class = options.delete(:extra_class))
            the_class = "#{the_class} #{extra_class}"
          end
          options[:class] = the_class
        end
        value
      end

      def setup_turbo_submit(submits_with)
        case submits_with
        when :spinner, "spinner"
          raw(<<~HTML.strip)
            <div class="spinner-border d-block mx-auto" role="status" style="--bs-spinner-width: 1lh; --bs-spinner-height: 1lh;"></div>
          HTML
        else
          submits_with.to_s
        end
      end
    end
  end
end
