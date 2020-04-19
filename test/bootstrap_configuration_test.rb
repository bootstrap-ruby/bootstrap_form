require_relative "./test_helper"

class BootstrapConfigurationTest < ActionView::TestCase
  test "has default form attributes" do
    config = BootstrapForm::Configuration.new

    assert_equal({ role: "form" }, config.default_form_attributes)
  end

  test "allows to set default_form_attributes with custom value" do
    config = BootstrapForm::Configuration.new
    config.default_form_attributes = { foo: "bar" }

    assert_equal({ foo: "bar" }, config.default_form_attributes)
  end

  test "allows to set default_form_attributes with nil" do
    config = BootstrapForm::Configuration.new
    config.default_form_attributes = nil

    assert_equal({ }, config.default_form_attributes)
  end

  test "does not allow to set default_form_attributes with unsupported value" do
    config = BootstrapForm::Configuration.new

    exception = assert_raises ArgumentError do
      config.default_form_attributes = [1,2,3]
    end
    assert_equal('Unsupported default_form_attributes [1, 2, 3]', exception.message)
  end
end
