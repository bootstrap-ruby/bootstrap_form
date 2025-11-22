# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module InputsCollection
      extend ActiveSupport::Concern

      private

      def inputs_collection(name, collection, value, text, options={}, &)
        if BootstrapForm.config.fieldset_around_collections
          return fieldset_inputs_collection(name, collection, value, text, options, &)
        end

        options[:label] ||= { class: group_label_class(field_layout(options)) }
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

      def field_layout(options) = options[:layout] || (:inline if options[:inline] == true)

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

      def fieldset_inputs_collection(name, collection, value, text, options={}, &)
        options[:label] ||= { class: group_label_class(options[:inline]) }
        options[:layout] ||= layout_inline?(options[:inline])

        fieldset_builder(name, options) do
          inputs = ActiveSupport::SafeBuffer.new

          collection.each_with_index do |obj, i|
            input_value = value.respond_to?(:call) ? value.call(obj) : obj.send(value)
            input_options = form_group_collection_input_options(options, text, obj, i, input_value, collection)
            inputs << yield(name, input_value, input_options)
          end

          inputs
        end
      end

      def fieldset_builder(method, options, html_options=nil, &)
        no_wrapper = options[:wrapper] == false

        options = form_group_builder_options(options, method)

        form_group_options = form_group_opts(options, form_group_css_options(method, html_options.try(:symbolize_keys!), options))

        options.except!(
          :help, :icon, :label_col, :control_col, :add_control_col_class, :layout, :skip_label, :label, :label_class,
          :hide_label, :skip_required, :label_as_placeholder, :wrapper_class, :wrapper
        )

        if no_wrapper
          yield
        else
          fieldset(method, form_group_options, &)
        end
      end

      def fieldset(name, options, &)
        options[:class] = form_group_classes(options)

        tag.fieldset(**options.except(
          :add_control_col_class, :append, :control_col, :floating, :help, :icon, :id,
          :input_group_class, :label, :label_col, :layout, :prepend
        )) do
          legend = generate_legend(name, options)
          prepare_label_options(options[:id], name, options[:label], options[:label_col], options[:layout])
          form_group_content(legend, generate_help(name, options[:help]), options, &)
        end
      end

      def generate_legend(name, options)
        legend_class = group_label_class(options[:layout])

        tag.legend(**{ class: legend_class }.compact) { label_text(name, options.dig(:label, :text)) }
      end
    end
  end
end
