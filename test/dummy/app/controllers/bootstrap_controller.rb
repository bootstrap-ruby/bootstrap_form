class BootstrapController < ApplicationController
  helper_method :codemirror_html

  def form
    @user = User.new
  end

private

  def codemirror_html(html)
    HtmlBeautifier.beautify(html.strip.gsub(">", ">\n").gsub("<", "\n<"))
  end

end