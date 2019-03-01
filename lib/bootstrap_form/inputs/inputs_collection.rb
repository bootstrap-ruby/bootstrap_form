module BootstrapForm
  module Inputs
    module InputsCollection
      extend ActiveSupport::Concern

      private

      def inputs_collection(name, collection, value, text, options={})
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

      # FIXME: Find a way to reduce the parameter list size
      # rubocop:disable Metrics/ParameterLists
      def form_group_collection_input_options(options, text, obj, index, input_value, collection)
        input_options = options.merge(label: text.respond_to?(:call) ? text.call(obj) : obj.send(text))
        if (checked = input_options[:checked])
          input_options[:checked] = form_group_collection_input_checked?(checked, obj, input_value)
        end

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
