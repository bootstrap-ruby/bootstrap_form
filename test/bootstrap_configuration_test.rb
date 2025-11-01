# frozen_string_literal: true

require_relative "test_helper"

class BootstrapConfigurationTest < ActionView::TestCase
  teardown do
    # Unfortunately, it seems we have to manually reset each of the configuration options
    # that we change in our test cases.
    Rails.application.config.bootstrap_form.default_form_attributes = {}
    Rails.application.config.bootstrap_form.bogon = nil
  end

  test "has default form attributes" do
    config = BootstrapForm::Configuration.new

    assert_deprecated(BootstrapForm.deprecator) do
      assert_equal({}, config.default_form_attributes)
    end
  end

  test "allows to set default_form_attributes with custom value" do
    config = BootstrapForm::Configuration.new
    assert_deprecated(BootstrapForm.deprecator) do
      config.default_form_attributes = { foo: "bar" }
    end

    assert_deprecated(BootstrapForm.deprecator) do
      assert_equal({ foo: "bar" }, config.default_form_attributes)
    end
  end

  test "allows to set default_form_attributes with nil" do
    config = BootstrapForm::Configuration.new
    config.default_form_attributes = nil

    assert_deprecated(BootstrapForm.deprecator) do
      assert_equal({}, config.default_form_attributes)
    end
  end

  test "does not allow to set default_form_attributes with unsupported value" do
    config = BootstrapForm::Configuration.new

    exception = assert_raises ArgumentError do
      config.default_form_attributes = [1, 2, 3]
    end
    assert_equal("Unsupported default_form_attributes [1, 2, 3]", exception.message)
  end

  test "Use Rails configuration" do
    assert_nil Rails.application.config.bootstrap_form.bogon
    Rails.application.config.bootstrap_form.bogon = true
    assert Rails.application.config.bootstrap_form.bogon
  end

  test "Support legacy configuration from Rails configuration" do
    assert_equal({}, Rails.application.config.bootstrap_form.default_form_attributes)

    config = BootstrapForm::Configuration.new
    assert_deprecated(BootstrapForm.deprecator) do
      config.default_form_attributes = { foo: "bar" }
    end

    assert_equal({ foo: "bar" }, Rails.application.config.bootstrap_form.default_form_attributes)
  end
end
