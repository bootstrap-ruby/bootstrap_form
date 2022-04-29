# frozen_string_literal: true

module BootstrapForm
  module FormGroup
    extend ActiveSupport::Concern

    def form_group(*args, &block)
      options = args.extract_options!
      name = args.first

      options[:class] = form_group_classes(options)

      tag.div(**options.except(:append, :id, :label, :help, :icon,
                               :input_group_class, :label_col, :control_col,
                               :add_control_col_class, :layout, :prepend, :floating)) do
        form_group_content(
          generate_label(options[:id], name, options[:label], options[:label_col], options[:layout]),
          generate_help(name, options[:help]), options, &block
        )
      end
    end

    private

    def form_group_content_tag(name, field_name, without_field_name, options, html_options)
      html_class = control_specific_class(field_name)
      html_class = "#{html_class} col-auto g-3" if @layout == :horizontal && options[:skip_inline].blank?
      tag.div(class: html_class) do
        input_with_error(name) do
          send(without_field_name, name, options, html_options)
        end
      end
    end

    def form_group_content(label, help_text, options, &block)
      if group_layout_horizontal?(options[:layout])
        concat(label).concat(tag.div(capture(&block) + help_text, class: form_group_control_class(options)))
      else
        # Floating labels need to be rendered after the field
        concat(label) unless options[:floating]
        concat(capture(&block))
        concat(label) if options[:floating]
        concat(help_text) if help_text
      end
    end

    def form_group_control_class(options)
      classes = [options[:control_col] || control_col]
      classes << options[:add_control_col_class] if options[:add_control_col_class]
      classes << offset_col(options[:label_col] || @label_col) unless options[:label]
      classes.flatten.compact
    end

    def form_group_classes(options)
      classes = options[:class] == false ? [] : (options[:class] || form_group_default_class).split
      classes << "row" if horizontal_group_with_gutters?(options[:layout], classes)
      classes << "col-auto g-3" if field_inline_override?(options[:layout])
      classes << feedback_class if options[:icon]
      classes << "form-floating" if options[:floating]
      classes.presence
    end

    def form_group_default_class
      (layout == :inline ? "col" : "mb-3")
    end

    def horizontal_group_with_gutters?(layout, classes)
      group_layout_horizontal?(layout) && !classes_include_gutters?(classes)
    end

    def group_layout_horizontal?(layout)
      get_group_layout(layout) == :horizontal
    end

    def classes_include_gutters?(classes)
      classes.any? { |c| c =~ /^g-\d+$/ }
    end
  end
end
