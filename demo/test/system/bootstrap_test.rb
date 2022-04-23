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

  private

  def bounds(node)
    client_rect = evaluate_script("arguments[0].getBoundingClientRect()", node.native)
    [client_rect["left"].floor, client_rect["top"].floor, client_rect["right"].ceil, client_rect["bottom"].ceil]
  end
end
