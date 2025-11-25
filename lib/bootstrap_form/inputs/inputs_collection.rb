# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module InputsCollection
      extend ActiveSupport::Concern

      private

      def inputs_collection(name, collection, value, text, options={}, &)
        options[:label] ||= { class: group_label_class(field_layout(options)) }
        options[:inline] ||= layout_inline?(options[:layout])

        return group_inputs_collection(name, collection, value, text, options, &) if BootstrapForm.config.group_around_collections

        form_group_builder(name, options) do
          render_collection(name, collection, value, text, options, &)
        end
      end

      def field_layout(options)
        (:inline if options[:inline] == true) || options[:layout]
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

      def group_inputs_collection(name, collection, value, text, options={}, &)
        group_builder(name, options) do
          render_collection(name, collection, value, text, options, &)
        end
      end

      def render_collection(name, collection, value, text, options={}, &)
        inputs = ActiveSupport::SafeBuffer.new

        collection.each_with_index do |obj, i|
          input_value = value.respond_to?(:call) ? value.call(obj) : obj.send(value)
          input_options = form_group_collection_input_options(options, text, obj, i, input_value, collection)
          inputs << yield(name, input_value, input_options)
        end

        inputs
      end

      def group_builder(method, options, html_options=nil, &)
        form_group_builder_wrapper(method, options, html_options) do |form_group_options, no_wrapper|
          if no_wrapper
            yield
          else
            field_group(method, form_group_options, &)
          end
        end
      end

      def field_group(name, options, &)
        options[:class] = form_group_classes(options)

        tag.div(
          **options.except(
            :add_control_col_class, :append, :control_col, :floating, :help, :icon, :id,
            :input_group_class, :label, :label_col, :layout, :prepend
          ),
          aria: { labelledby: options[:id] || default_id(name) },
          role: :group
        ) do
          group_label_div = generate_group_label_div(name, options)
          prepare_label_options(options[:id], name, options[:label], options[:label_col], options[:layout])
          form_group_content(group_label_div, generate_help(name, options[:help]), options, &)
        end
      end

      def generate_group_label_div(name, options)
        group_label_div_class = options.dig(:label, :class) || "form-label"
        id = options[:id] || default_id(name)

        tag.div(
          **{ class: group_label_div_class }.compact,
          id:
        ) { label_text(name, options.dig(:label, :text)) }
      end

      def default_id(name) = raw("#{object_name}_#{name}") # rubocop:disable Rails/OutputSafety
    end
  end
end
