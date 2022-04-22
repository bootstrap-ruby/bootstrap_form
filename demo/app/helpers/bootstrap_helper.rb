module BootstrapHelper
  def form_with_source(&block)
    form_html = capture(&block)

    tag.div(class: "example") do
      concat(form_html)
      concat(toggle)
      concat(codemirror(form_html))
    end
  end

  private

  def codemirror(form_html)
    tag.div(class: "code", style: "display: none") do
      tag.textarea(class: "codemirror") do
        HtmlBeautifier.beautify(form_html.strip.gsub(">", ">\n").gsub("<", "\n<"))
      end
    end
  end

  def toggle
    tag.button(class: "toggle btn btn-sm btn-info") do
      "Toggle Source Code"
    end
  end
end
