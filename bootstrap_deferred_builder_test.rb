# frozen_string_literal: true

require_relative "./test_helper"

class BootstrapDeferredBuilderTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  test "create a deferred builder for a radio button" do
    assert what_we_got = BootstrapForm::DeferredBuilder::RadioButton.new(:email, @builder)
    assert what_we_got.is_a?(BootstrapForm::DeferredBuilder::RadioButton)
    assert_equal '<div class="form-check"></div>', what_we_got.to_s
  end
end
