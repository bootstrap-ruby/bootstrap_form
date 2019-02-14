# frozen_string_literal: true

require "test_helper"

class BootstrapErrorRenderingTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  def setup
    setup_test_fixture
  end

  test "Default error message" do
    @user.email = nil
    @user.valid?

    expected = <<-HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="required" for="user_email">Email</label>
          <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
        </div>
      </form>
    HTML

    assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| f.text_field :email }
  end

  test "form_group error message" do
    @user.email = nil
    @user.valid?

    output = @builder.form_group :email do
      '<p class="form-control-static">Bar</p>'.html_safe
    end

    expected = <<-HTML
      <div class="form-group">
        <p class="form-control-plaintext">Bar</p>
        <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
      </div>
    HTML

    assert_equivalent_xml expected, output
  end

  test "check_box wrapped in form_group error message" do
    @user.errors.add :terms, "an error for testing"

    output = bootstrap_form_for(@user) do |f|
      f.form_group(:terms) do
        f.check_box(:terms, label: "I agree to the terms")
      end
    end

    expected = <<-HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <div class="form-check">
            <input name="user[terms]" type="hidden" value="0"/>
            <input class="form-check-input is-invalid" id="user_terms" name="user[terms]" type="checkbox" value="1"/>
            <label class="form-check-label" for="user_terms">I agree to the terms</label>
            <div class="invalid-feedback">an error for testing</div>
          </div>
        </div>
      </form>
    HTML

    assert_equivalent_xml expected, output
  end

  test "radio_button wrapped in form_group error message" do
    @user.errors.add :misc, "an error for testing"

    output = bootstrap_form_for(@user) do |f|
      f.form_group(:misc) do
        f.radio_button(:misc, "1", label: "This is a radio button")
      end
    end

    expected = <<-HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_1" name="user[misc]" type="radio" value="1"/>
            <label class="form-check-label" for="user_misc_1">This is a radio button</label>
            <div class="invalid-feedback">an error for testing</div>
          </div>
        </div>
      </form>
    HTML

    assert_equivalent_xml expected, output
  end

  test "bare check_box error message" do
    @user.errors.add :terms, "an error for testing"

    output = bootstrap_form_for(@user) do |f|
      f.check_box(:terms, label: "I agree to the terms")
    end

    expected = <<-HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-check">
          <input name="user[terms]" type="hidden" value="0"/>
          <input class="form-check-input is-invalid" id="user_terms" name="user[terms]" type="checkbox" value="1"/>
          <label class="form-check-label" for="user_terms">I agree to the terms</label>
          <div class="invalid-feedback">an error for testing</div>
        </div>
      </form>
    HTML

    assert_equivalent_xml expected, output
  end

  test "bare radio_button error message" do
    @user.errors.add :misc, "an error for testing"

    output = bootstrap_form_for(@user) do |f|
      f.radio_button(:misc, "1", label: "This is a radio button")
    end

    expected = <<-HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-check">
          <input class="form-check-input is-invalid" id="user_misc_1" name="user[misc]" type="radio" value="1"/>
          <label class="form-check-label" for="user_misc_1">This is a radio button</label>
          <div class="invalid-feedback">an error for testing</div>
        </div>
      </form>
    HTML

    assert_equivalent_xml expected, output
  end
end
