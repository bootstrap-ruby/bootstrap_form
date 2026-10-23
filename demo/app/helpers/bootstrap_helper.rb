# frozen_string_literal: true

module BootstrapHelper
  def form_with_source(&)
    form_html = capture(&)

    tag.div(class: "example card p-12 mb-12") do
      concat(form_html)
      concat(toggle)
      concat(codemirror(form_html))
    end
  end

  private

  def codemirror(form_html)
    tag.div(class: "code mt-6", style: "display: none") do
      tag.textarea(class: "codemirror") do
        HtmlBeautifier.beautify(form_html.strip.gsub(">", ">\n").gsub("<", "\n<"))
      end
    end
  end

  def toggle
    tag.button(class: "toggle btn-subtle theme-accent mt-6 align-self-start") do
      "Toggle Source Code"
    end
  end
end
