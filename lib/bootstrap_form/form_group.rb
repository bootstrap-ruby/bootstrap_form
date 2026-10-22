# frozen_string_literal: true

module BootstrapForm
  module FormGroup
    extend ActiveSupport::Concern

    def form_group(*args, &block)
      options = args.extract_options!
      name = args.first

      options[:class] = form_group_classes(options)

      tag.div(**options.except(:add_control_col_class, :append, :control_col, :floating, :help, :icon, :id,
                               :input_group_class, :label, :label_col, :layout, :prepend)) do
        content = capture(&block) || ActiveSupport::SafeBuffer.new
        label = generate_label(options[:id], name, options[:label], options[:label_col], options[:layout])
        label = detach_dangling_label(label, content)
        form_group_content(label, generate_help(name, options[:help], id: options[:id]), options) { content }
      end
    end

    private

    # A group label (e.g. above a set of radios) gets a `for` attribute from
    # Rails that matches no control. Drop it so the label isn't associated
    # with a non-existent element, as in the Bootstrap docs' grouped fields.
    def detach_dangling_label(label, content)
      return label unless label && (for_id = label[/ for="([^"]*)"/, 1]) && content.exclude?(" id=\"#{for_id}\"")

      label.sub(/ for="[^"]*"/, "").html_safe # rubocop:disable Rails/OutputSafety
    end

    def form_group_content_tag(name, field_name, without_field_name, options, html_options)
      html_class = control_specific_class(field_name)
      html_class = "#{html_class} col-auto g-3" if @layout == :horizontal && options[:skip_inline].blank?
      tag.div(class: html_class) do
        input_with_error(name, options) do
          send(without_field_name, name, options, html_options)
        end
      end
    end

    def form_group_content(label, help_text, options, &)
      label ||= ActiveSupport::SafeBuffer.new
      if group_layout_horizontal?(options[:layout])
        label + tag.div(capture(&) + help_text, class: form_group_control_class(options))
      else
        content = ActiveSupport::SafeBuffer.new
        # Bootstrap 6 renders labels (including floating labels) before the field
        content << label
        content << capture(&)
        content << help_text if help_text
        content
      end
    end

    def form_group_control_class(options)
      classes = [options[:control_col] || control_col]
      classes << options[:add_control_col_class] if options[:add_control_col_class]
      classes << offset_col(options[:label_col] || @label_col) unless options[:label]
      classes.flatten.compact
    end

    def form_group_classes(options, default_class: form_group_default_class(options))
      classes = options[:class] == false ? [] : (options[:class] || default_class).split
      classes << "row" if horizontal_group_with_gutters?(options[:layout], classes)
      classes << "col-auto g-3" if field_inline_override?(options[:layout])
      classes << feedback_class if options[:icon]
      classes.presence
    end

    # Bootstrap 6 wraps controls with their label, help text and validation
    # feedback in a `form-field` grid. Horizontal and inline groups place the
    # label next to the control instead of above it, so they don't get the
    # `form-field` grid.
    def form_group_default_class(options)
      return "col" if layout == :inline

      if get_group_layout(options[:layout]) == :inline || group_layout_horizontal?(options[:layout])
        "mb-5"
      else
        "form-field mb-5"
      end
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
