require_relative "./test_helper"

class BootstrapConfigurationTest < ActionView::TestCase
  test "has default form attributes" do
    config = BootstrapForm::Configuration.new

    assert_equal({ role: "form" }, config.default_form_attributes)
  end

  test "allows to set default_form_attributes" do
    config = BootstrapForm::Configuration.new
    config.default_form_attributes = { foo: "bar" }

    assert_equal({ foo: "bar" }, config.default_form_attributes)
  end
end
