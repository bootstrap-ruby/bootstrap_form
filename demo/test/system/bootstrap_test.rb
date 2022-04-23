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
      screenshot header.text.downcase.tr(" ", "_"), crop: bounds(example)
    end
  end

  test "readme examples" do
    screenshot_group :readme

    readme = File.read(File.expand_path("../../../README.md", __dir__))
    readme_with_images = readme.gsub(/(?:!\[[^]]*\]\([^)]+\)\s*)?```erb\n(.*?)\n```\s*/m).with_index do |_, i|
      erb = $1
      visit root_path erb: erb
      screenshot :example, crop: bounds(find('.p-3'))
      <<~MD
        ![Example #{i + 1}](demo/doc/screenshots/bootstrap/readme/#{'%02i' % i}_example.png "Example #{i + 1}")
        ```erb
        #{erb}
        ```\n
      MD
    end
    File.write(File.expand_path("../../../README.md", __dir__), readme_with_images)
  end

  private

  def bounds(node)
    client_rect = evaluate_script("arguments[0].getBoundingClientRect()", node.native)
    [client_rect["left"].floor, client_rect["top"].floor, client_rect["right"].ceil, client_rect["bottom"].ceil]
  end
end
