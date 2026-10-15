# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module Base
      extend ActiveSupport::Concern

      class_methods do
        def bootstrap_field(field_name)
          define_method :"#{field_name}_with_bootstrap" do |name, options={}|
            warn_deprecated_layout_value(options)
            options = field_default_options(field_name, options)
            return floating_input_group_field(field_name, name, options) if floating_input_group?(options)

            form_group_builder(name, options) do
              prepend_and_append_input(name, options) do
                options[:placeholder] ||= name if options[:floating]
                decorate_field(field_name, options) do
                  send(:"#{field_name}_without_bootstrap", name, options.except(:floating, :adorn, :range, :strength))
                end
              end
            end
          end

          bootstrap_alias field_name
        end

        def bootstrap_select_group(field_name)
          define_method(:"#{field_name}_with_bootstrap") do |name, options={}, html_options={}|
            # Specifying the id for a select doesn't work. The Rails helpers need to generate
            # what they generate, and that includes the ids for each select option.
            options.delete(:id)
            html_options = html_options.reverse_merge(control_class: "form-control")
            form_group_builder(name, options, html_options) do
              form_group_content_tag(name, field_name, "#{field_name}_without_bootstrap", options, html_options)
            end
          end

          bootstrap_alias field_name
        end

        # Creates the methods *_without_bootstrap and *_with_bootstrap.
        #
        # If your application did not include the rails gem for one of the dsl
        # methods, then a name error is raised and suppressed. This can happen
        # if your application does not include the actiontext dependency due to
        # `rich_text_area` not being defined.
        def bootstrap_alias(field_name)
          alias_method :"#{field_name}_without_bootstrap", field_name
          alias_method field_name, :"#{field_name}_with_bootstrap"
        rescue NameError # rubocop:disable Lint/SuppressedException
        end
      end

      private

      def field_default_options(field_name, options)
        case field_name
        when :range_field then options.reverse_merge(control_class: "form-range-input")
        when :color_field then options.reverse_merge(control_class: "form-control form-control-color")
        else options[:adorn] ? options.reverse_merge(control_class: "form-ghost") : options
        end
      end

      def floating_input_group?(options)
        options[:floating] && (options[:prepend] || options[:append])
      end

      # Bootstrap 6 nests `form-floating` inside the `input-group`, with the
      # validation feedback outside the group as a sibling in the form field.
      def floating_input_group_field(field_name, name, options)
        options.merge!(required_field_options(options, name))
        floating_label = generate_label(options[:id], name, form_group_label(options, { id: options[:id] }), nil, nil)
        options[:placeholder] ||= name
        options[:skip_label] = true
        options[:floating] = false
        form_group_builder(name, options) do
          prepend_and_append_input(name, options) do
            field = send(:"#{field_name}_without_bootstrap", name, options.except(:floating, :adorn, :range, :strength))
            tag.div(floating_label + field, class: ["form-floating", ("is-invalid" if error?(name))].compact)
          end
        end
      end

      # Bootstrap 6 decorations around the bare field: the form-range wrapper,
      # form-adorn wrappers, and the password strength meter.
      def decorate_field(field_name, options)
        field = yield
        field = range_wrapper(field, options[:range]) if field_name == :range_field
        field = adorn_wrapper(field, options[:adorn]) if options[:adorn]
        field << strength_meter(options[:strength]) if options[:strength]
        field
      end

      # Bootstrap 6 wraps range inputs in a `form-range` div that carries the
      # theme classes and the `data-bs-bubble` value bubble. `range: "theme-primary"`
      # adds classes; `range: { bubble: true, class: "..." }` also enables the bubble.
      def range_wrapper(field, range)
        range = { class: range } unless range.is_a?(Hash)
        data = { bs_bubble: "" } if range[:bubble]
        tag.div(field, class: ["form-range", range[:class]].compact, data:, **range.except(:bubble, :class))
      end

      # Rails prefixes the form namespace onto ids it generates; helpers that
      # render an element themselves need to do the same.
      def namespaced_id(id)
        [@options[:namespace], id].compact.join("_")
      end

      def warn_deprecated_layout_value(options)
        return unless options[:layout] == :default

        warn "Layout `:default` is deprecated, use `:vertical` instead."
        options[:layout] = :vertical
      end
    end
  end
end
