# frozen_string_literal: true

require_relative "test_helper"

class BootstrapRadioButtonTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  test "radio_button is wrapped correctly" do
    expected = <<~HTML
      <div class="form-field">
        <input class="radio" extra="extra arg" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.radio_button(:misc, "1", label: "This is a radio button", extra: "extra arg")
  end

  test "radio_button no label" do
    expected = <<~HTML
      <div class="form-field">
        <input class="radio" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label for="user_misc_1">&#8203;</label>
      </div>
    HTML
    # &#8203; is a zero-width space.
    assert_equivalent_html expected, @builder.radio_button(:misc, "1", label: "&#8203;".html_safe)
  end

  test "radio_button with error is wrapped correctly" do
    @user.errors.add(:misc, "error for test")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="form-field">
          <input class="radio is-invalid" id="user_misc_1" aria-describedby="user_misc_feedback" name="user[misc]" type="radio" value="1" />
          <div class="form-field-content">
            <label for="user_misc_1">
              This is a radio button
            </label>
            <div class="invalid-feedback" id="user_misc_feedback">error for test</div>
          </div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user) do |f|
      f.radio_button(:misc, "1", label: "This is a radio button", error_message: true)
    end
    assert_equivalent_html expected, actual
  end

  test "radio_button with error is wrapped correctly with specified id:" do
    @user.errors.add(:misc, "error for test")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="form-field">
          <input class="radio is-invalid" id="custom-id" aria-describedby="custom-id_feedback" name="user[misc]" type="radio" value="1" />
          <div class="form-field-content">
            <label for="custom-id">
              This is a radio button
            </label>
            <div class="invalid-feedback" id="custom-id_feedback">error for test</div>
          </div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user) do |f|
      f.radio_button(:misc, "1", label: "This is a radio button", error_message: true, id: "custom-id")
    end
    assert_equivalent_html expected, actual
  end

  test "radio_button disabled label is set correctly" do
    expected = <<~HTML
      <div class="form-field disabled">
        <input class="radio" disabled="disabled" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.radio_button(:misc, "1", label: "This is a radio button", disabled: true)
  end

  test "radio_button label class is set correctly" do
    expected = <<~HTML
      <div class="form-field">
        <input class="radio" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="btn" for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.radio_button(:misc, "1", label: "This is a radio button", label_class: "btn")
  end

  test "radio_button 'id' attribute is used to specify label 'for' attribute" do
    expected = <<~HTML
      <div class="form-field">
        <input class="radio" id="custom_id" name="user[misc]" type="radio" value="1" />
        <label for="custom_id">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.radio_button(:misc, "1", label: "This is a radio button", id: "custom_id")
  end

  test "radio_button inline label is set correctly" do
    expected = <<~HTML
      <div class="form-field d-inline-grid me-3">
        <input class="radio" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.radio_button(:misc, "1", label: "This is a radio button", inline: true)
  end

  test "radio_button inline label is set correctly from form level" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user row row-cols-auto g-3 align-items-center" id="new_user" method="post">
        <div class="form-field d-inline-grid me-3">
          <input class="radio" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label for="user_misc_1">
            This is a radio button
          </label>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user, layout: :inline) do |f|
      f.radio_button(:misc, "1", label: "This is a radio button")
    end
    assert_equivalent_html expected, actual
  end

  test "radio_button disabled inline label is set correctly" do
    expected = <<~HTML
      <div class="form-field d-inline-grid me-3 disabled">
        <input class="radio" disabled="disabled" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.radio_button(:misc, "1", label: "This is a radio button", inline: true, disabled: true)
  end

  test "radio_button inline label class is set correctly" do
    expected = <<~HTML
      <div class="form-field d-inline-grid me-3">
        <input class="radio" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="btn" for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.radio_button(:misc, "1", label: "This is a radio button", inline: true, label_class: "btn")
  end

  test "radio button skip label" do
    expected = <<~HTML
      <div class="form-field">
        <input class="radio position-static" id="user_misc_1" name="user[misc]" type="radio" value="1" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.radio_button(:misc, "1", label: "This is a radio button", skip_label: true)
  end

  test "radio button hide label" do
    expected = <<~HTML
      <div class="form-field">
        <input class="radio position-static" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="visually-hidden" for="user_misc_1">This is a radio button</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.radio_button(:misc, "1", label: "This is a radio button", hide_label: true)
  end

  test "radio button with custom wrapper class" do
    expected = <<~HTML
      <div class="form-field custom-class">
        <input class="radio" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.radio_button(:misc, "1", label: "This is a radio button", wrapper_class: "custom-class")
  end

  test "radio button with wrapper class false" do
    expected = <<~HTML
      <div class="form-field">
        <input class="radio" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.radio_button(:misc, "1", label: "This is a radio button", wrapper_class: false)
    assert_equivalent_html expected,
                           @builder.radio_button(:misc, "1", label: "This is a radio button", wrapper: { class: false })
  end

  test "inline radio button with custom wrapper class" do
    expected = <<~HTML
      <div class="form-field d-inline-grid me-3 custom-class">
        <input class="radio" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.radio_button(:misc, "1", label: "This is a radio button", inline: true,
                                                             wrapper_class: "custom-class")
  end

  test "a required radiobutton" do
    expected = <<~HTML
      <div class="form-field">
        <input class="radio" id="user_misc_0" name="user[misc]" required="required" type="radio" value="0" />
        <label for="user_misc_0">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.radio_button(:misc, "0", label: "This is a radio button", required: true)
  end

  test "a required attribute as radiobutton" do
    expected = <<~HTML
      <div class="form-field">
        <input class="radio" id="user_email_0" name="user[email]" required="required" type="radio" value="0" />
        <label for="user_email_0">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.radio_button(:email, "0", label: "This is a radio button")
  end
end
