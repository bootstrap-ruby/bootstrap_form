module BootstrapForm
  module Inputs
    module InputsCollection
      extend ActiveSupport::Concern

      private

      def inputs_collection(name, collection, value, text, options={})
        options[:label] ||= { class: group_label_class(options[:layout]) }
        options[:inline] ||= layout_inline?(options[:layout])

        form_group_builder(name, options) do
          inputs = ActiveSupport::SafeBuffer.new

          collection.each_with_index do |obj, i|
            input_value = value.respond_to?(:call) ? value.call(obj) : obj.send(value)
            input_options = form_group_collection_input_options(options, text, obj, i, input_value, collection)
            inputs << yield(name, input_value, input_options)
          end

          inputs
        end
      end

      def group_label_class(field_layout)
        if layout_horizontal?(field_layout)
          group_label_class = "col-form-label #{label_col} pt-0"
        elsif layout_inline?(field_layout)
          group_label_class = "form-check form-check-inline ps-0"
        end
        group_label_class
      end

      # FIXME: Find a way to reduce the parameter list size
      # rubocop:disable Metrics/ParameterLists
      def form_group_collection_input_options(options, text, obj, index, input_value, collection)
        input_options = options.merge(label: text.respond_to?(:call) ? text.call(obj) : obj.send(text))
        if (checked = input_options[:checked])
          input_options[:checked] = form_group_collection_input_checked?(checked, obj, input_value)
        end

        # add things like 'data-' attributes to the HTML
        obj.each { |inner_obj| input_options.merge!(inner_obj) if inner_obj.is_a?(Hash) } if obj.respond_to?(:each)

        input_options[:error_message] = index == collection.size - 1
        input_options.except!(:class)
        input_options
      end
      # rubocop:enable Metrics/ParameterLists

      def form_group_collection_input_checked?(checked, obj, input_value)
        checked == input_value || Array(checked).try(:include?, input_value) ||
          checked == obj || Array(checked).try(:include?, obj)
      end
    end
  end
end
