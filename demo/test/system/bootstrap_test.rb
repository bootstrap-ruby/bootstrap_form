require "application_system_test_case"

class BootstrapTest < ApplicationSystemTestCase
  setup { screenshot_section :bootstrap }

  test "visiting the index" do
    screenshot_group :index
    visit root_url

    all(".toggle").each { |btn| execute_script "arguments[0].remove()", btn }

    all("h3").each do |header|
      example = header.first(:xpath, "./following-sibling::div")
      scroll_to example
      sleep 0.5
      screenshot header.text.downcase.tr(" ", "_"), crop: bounds(example), color_distance_limit: 2
    end
  end

  HEADERS = ["Generated HTML", "This generates", "Which outputs", "will be rendered as"].join("|").freeze
  REGEXP =
    /(?:!\[[^\]]*\]\([^)]+\)\s*)?```erb\n(.*?)\n```\s*((?:#{HEADERS}).*?$)?\s*(```html\n(?:.*?)\n```\s*)?/mi
    .freeze
  test "readme examples" do
    screenshot_group :readme

    readme = File.read(File.expand_path("../../../README.md", __dir__))
    augmented_readme = readme.gsub(REGEXP) do |_|
      erb = Regexp.last_match(1)
      header = Regexp.last_match(2)
      unless /\A<%= bootstrap[^>]*>\n\s*...\s*<% end %>\z/.match? erb
        wrapped_erb = erb.starts_with?("<%= bootstrap") ? erb : <<~ERB
          <%= bootstrap_form_with model: @user do |f| %>
            #{erb}
          <% end %>
        ERB

        visit fragment_path erb: wrapped_erb
        wrapper = find(".p-3")
        i = @screenshot_counter
        screenshot :example, crop: bounds(wrapper)
        wrapper = wrapper.find("form") if wrapped_erb != erb
        html = wrapper["innerHTML"].strip.gsub("><", ">\n<")
        assert html.present?, erb
        doc = Nokogiri::HTML.fragment(html)
        doc.traverse do |node|
          if node.is_a?(Nokogiri::XML::Element)
            node.attributes.sort_by(&:first).each do |name, value|
              node.delete(name)
              node[name] = value
            end
          end
        end
        html = doc.to_html
        image = <<~MD
          ![Example #{i}](demo/doc/screenshots/bootstrap/readme/#{format('%02i', i)}_example.png "Example #{i}")
        MD
        html = <<~MD

          #{header || 'Generated HTML:'}

          ```html
          #{HtmlBeautifier.beautify(html)}
          ```
        MD
      end
      <<~MD
        #{image}```erb
        #{erb}
        ```
        #{html}
      MD
    end
    augmented_readme.gsub!(/127.0.0.1:\d+/, "test.host")
    File.write(File.expand_path("../../../README.md", __dir__), augmented_readme)
  end

  private

  def bounds(node)
    client_rect = evaluate_script("arguments[0].getBoundingClientRect()", node.native)
    [client_rect["left"].floor, client_rect["top"].floor, client_rect["right"].ceil, client_rect["bottom"].ceil]
  end
end
