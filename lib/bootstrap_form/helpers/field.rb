module BootstrapForm
  module Helpers
    module Field
      def required_field_options(options, method)
        required = required_field?(options, method)
        {}.tap do |option|
          if required
            option[:required] = true
            option[:aria] ||= {}
            option[:aria][:required] = true
          end
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
