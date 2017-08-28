require_relative 'aliasing'
require_relative 'helpers/bootstrap'

module BootstrapForm
  class FormBuilderFormWith < FormBuilder

    def add_for_option_if_needed!(options, id)
      options[:for] ||= id
    end

    # Override this method to be consistent with `form_with` behaviour not to
    # generate default DOM ids.
    def convert_form_tag_options(method, options = {})
      # options[:name] ||= method
      # options[:id] ||= method
      options
    end

    def form_group_builder(method, options, html_options = nil)
      options.symbolize_keys!
      if html_options
        html_options.symbolize_keys!
        options[:id] = html_options[:id]
      end
      super
    end

    ##
    # Turn off the automatic generation of ids.
    def initialize(object_name, object, template, options)
      # TODO: Check if `form_with` really is just using this option to turn off default ids.
      options[:skip_default_ids] = true if options[:skip_default_ids].nil?
      super
    end

    ##
    # Use the explicit for: option or the id: if specified in the label
    # for the field.
    def label_for_from_options(options)
      if options.has_key?(:for)
        { for: options[:for] }
      elsif options.has_key?(:id)
        { for: options[:id] }
      else
        { for: nil }
      end
    end
  end
end
