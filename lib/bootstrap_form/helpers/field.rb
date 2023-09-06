module BootstrapForm
  module Helpers
    module Field
      def required_field_options(options, method)
        required = required_field?(options, method)
        {}.tap do |option|
          option[:required] = true if required
        end
      end

      private

      def required_field?(options, method)
        if options[:skip_required]
          warn "`:skip_required` is deprecated, use `:required: false` instead"
          false
        elsif options.key?(:required)
          options[:required]
        else
          required_attribute?(object, method)
        end
      end
    end
  end
end
