# frozen_string_literal: true

module BootstrapForm
  module FormGroup
    extend ActiveSupport::Concern

    def form_group(*args, &block)
      options = args.extract_options!
      name = args.first

      options[:class] = form_group_classes(options)

      content_tag(:div, options.except(:append, :id, :label, :help, :icon,
                                       :input_group_class, :label_col, :control_col,
                                       :add_control_col_class, :layout, :prepend)) do
        form_group_content(
          generate_label(options[:id], name, options[:label], options[:label_col], options[:layout]),
          generate_help(name, options[:help]), options, &block
        )
      end
    end

    private

    def form_group_content_tag(name, field_name, without_field_name, options, html_options)
      html_class = control_specific_class(field_name)
      html_class = "#{html_class} form-inline" if @layout == :horizontal && options[:skip_inline].blank?
      content_tag(:div, class: html_class) do
        input_with_error(name) do
          send(without_field_name, name, options, html_options)
        end
      end
    end

    def form_group_content(label, help_text, options, &block)
      if group_layout_horizontal?(options[:layout])
        content = if help_text
                    capture(&block) + help_text
                  else
                    capture(&block)
                  end

        concat(label).concat(content_tag(:div, content, class: form_group_control_class(options)))
      else
        concat(label)
        concat(capture(&block))
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
      classes = ["form-group", options[:class].try(:split)].flatten.compact
      classes << "row" if group_layout_horizontal?(options[:layout]) && classes.exclude?("form-row")
      classes << "form-inline" if field_inline_override?(options[:layout])
      classes << feedback_class if options[:icon]
      classes
    end

    def group_layout_horizontal?(layout)
      get_group_layout(layout) == :horizontal
    end
  end
end
