# frozen_string_literal: true

require_relative "test_helper"

class BootstrapV6ComponentsTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  test "adorned field with text" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <label class="form-control form-adorn">
          <span aria-hidden="true" class="form-adorn-text">$</span>
          <input class="form-ghost" id="user_misc" name="user[misc]" type="text" />
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.text_field(:misc, adorn: "$")
  end

  test "adorned field with trailing text and custom classes" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <label class="form-control form-adorn form-adorn-end form-control-lg form-adorn-lg">
          <span aria-hidden="true" class="form-adorn-text">@example.com</span>
          <input class="form-ghost" id="user_misc" name="user[misc]" type="text" />
        </div>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.text_field(:misc, adorn: { text: "@example.com", end: true,
                                                               class: "form-control-lg form-adorn-lg" })
  end

  test "adorned field with icon" do
    icon = '<svg class="bi" width="16" height="16"><use href="#search"/></svg>'.html_safe
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <label class="form-control form-adorn">
          <div aria-hidden="true" class="form-adorn-icon">#{icon}</div>
          <input class="form-ghost" id="user_misc" name="user[misc]" type="search" />
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.search_field(:misc, adorn: { icon: icon })
  end

  test "password field with strength meter" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_password">Password</label>
        <input aria-describedby="user_password_help" class="form-control" id="user_password" name="user[password]" type="password" />
        <div class="strength" data-bs-strength="">
          <div class="strength-segment"></div>
          <div class="strength-segment"></div>
          <div class="strength-segment"></div>
          <div class="strength-segment"></div>
        </div>
        <small class="form-text" id="user_password_help">A good password should be at least six characters long</small>
      </div>
    HTML
    assert_equivalent_html expected, @builder.password_field(:password, strength: true)
  end

  test "password field with strength bar, text and min length" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_password">Password</label>
        <input class="form-control" id="user_password" name="user[password]" type="password" />
        <div class="strength-bar" data-bs-strength="" data-bs-min-length="12"></div>
        <span class="strength-text"></span>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.password_field(:password, help: false,
                                                              strength: { variant: :bar, min_length: 12, text: true })
  end

  test "otp field is wrapped correctly" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="otp" data-bs-otp="">
          <input autocomplete="one-time-code" class="otp-input" id="user_misc" maxlength="6" name="user[misc]" type="text" />
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.otp_field(:misc)
  end

  test "otp field renders otp options as data attributes" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="otp otp-connected" data-bs-otp="" data-bs-type="numeric" data-bs-groups="[3,3]" data-bs-separator="-">
          <input autocomplete="one-time-code" class="otp-input" id="user_misc" maxlength="8" name="user[misc]" type="text" />
        </div>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.otp_field(:misc, maxlength: 8,
                                                     otp: { class: "otp-connected", type: :numeric,
                                                            groups: [3, 3], separator: "-" })
  end

  test "otp field with error puts is-invalid on the container" do
    @user.errors.add(:misc, "error for test")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="form-field mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="otp is-invalid" data-bs-otp="">
            <input autocomplete="one-time-code" class="otp-input is-invalid" id="user_misc" aria-describedby="user_misc_feedback" maxlength="6" name="user[misc]" type="text" />
          </div>
          <div class="invalid-feedback" id="user_misc_feedback">error for test</div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |f| f.otp_field(:misc) }
  end

  test "form validate option adds data-bs-validate and novalidate" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" data-bs-validate="" id="new_user" method="post" novalidate="novalidate">
        <div class="form-field mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user, validate: true) { |f| f.text_field(:email) }
  end

  test "form validate option accepts valid for success styling" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" data-bs-validate="valid" id="new_user" method="post" novalidate="novalidate">
        <div class="form-field mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user, validate: "valid") { |f| f.text_field(:email) }
  end

  test "check_box with help renders form-field-content" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input aria-describedby="user_terms_help" class="check" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <div class="form-field-content">
          <label for="user_terms">I agree to the terms</label>
          <small class="form-text" id="user_terms_help">Read them carefully.</small>
        </div>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.check_box(:terms, label: "I agree to the terms", help: "Read them carefully.")
  end

  test "password_field with a static strength level" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_password">Password</label>
        <input class="form-control" id="user_password" name="user[password]" type="password" />
        <div class="strength" data-bs-input=":not(*)" data-bs-strength="good">
          <div class="strength-segment active"></div>
          <div class="strength-segment active"></div>
          <div class="strength-segment active"></div>
          <div class="strength-segment"></div>
        </div>
        <span class="strength-text">Good password</span>
      </div>
      <div class="form-field mb-3">
        <label class="form-label" for="user_password">Password</label>
        <input class="form-control" id="user_password" name="user[password]" type="password" />
        <div class="strength-bar" data-bs-input=":not(*)" data-bs-strength="weak"></div>
      </div>
    HTML
    actual = @builder.password_field(:password, help: false, strength: { level: :good, text: "Good password" }) +
             @builder.password_field(:password, help: false, strength: { variant: :bar, level: :weak })
    assert_equivalent_html expected, actual
  end

  test "adorned field with an error marks the wrapper invalid" do
    @user.errors.add(:misc, "is invalid")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="form-field mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <label class="form-control form-adorn is-invalid">
            <span aria-hidden="true" class="form-adorn-text">$</span>
            <input aria-describedby="user_misc_feedback" class="form-ghost is-invalid" id="user_misc" name="user[misc]" type="text" />
          </label>
          <div class="invalid-feedback" id="user_misc_feedback">is invalid</div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user) { |f| f.text_field(:misc, adorn: "$") }
    assert_equivalent_html expected, actual
  end
end
