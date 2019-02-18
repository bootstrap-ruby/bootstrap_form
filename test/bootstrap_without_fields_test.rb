require_relative "./test_helper"

class BootstrapWithoutFieldsTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  test "color fields are unwrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" name="user[misc]" type="color" value="#000000"/>
    HTML
    assert_equivalent_xml expected, @builder.color_field_without_bootstrap(:misc)
  end
end
