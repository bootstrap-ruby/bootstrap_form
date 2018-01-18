module BootstrapHelper

  def form_with_source(&block)
    form_html = capture(&block)

    content_tag(:div, class: "example") do
      codemirror = content_tag(:div, class: "code", style: "display: none") do
        content_tag(:textarea, class: "codemirror") do
          HtmlBeautifier.beautify(form_html.strip.gsub(">", ">\n").gsub("<", "\n<"))
        end
      end

      toggle = content_tag(:button, class: "toggle btn btn-sm btn-info") do
        "Show Source Code"
      end

      concat(form_html)
      concat(toggle)
      concat(codemirror)
    end
  end

end
