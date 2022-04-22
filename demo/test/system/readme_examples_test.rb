require "application_system_test_case"

class ReadmeExamplesTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_url

    assert_selector "h3", text: "Horizontal Form"
  end
end
