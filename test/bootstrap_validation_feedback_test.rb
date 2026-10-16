# frozen_string_literal: true

require_relative "test_helper"

class BootstrapValidationFeedbackTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  test "text_field with static invalid and valid feedback" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label required" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" required="required" type="text" />
        <div class="invalid-feedback">Please fill this in.</div>
        <div class="valid-feedback">Looks good!</div>
      </div>
    HTML
    actual = @builder.text_field(:misc, required: true, invalid_feedback: "Please fill this in.", valid_feedback: "Looks good!")
    assert_equivalent_html expected, actual
  end

  test "feedback as tooltips and the valid state" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control is-valid" id="user_misc" name="user[misc]" type="text" />
        <div class="tooltip valid-tooltip">Looks good!</div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.text_field(:misc, valid: true, valid_feedback: "Looks good!", tooltip: true)
  end

  test "model errors take precedence over static invalid feedback" do
    @user.errors.add(:misc, "is invalid")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="form-field mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <input aria-describedby="user_misc_feedback" class="form-control is-invalid" id="user_misc" name="user[misc]" type="text" />
          <div class="tooltip invalid-tooltip" id="user_misc_feedback">is invalid</div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user) { |f| f.text_field(:misc, invalid_feedback: "Please fill this in.", tooltip: true) }
    assert_equivalent_html expected, actual
  end

  test "check_box, select and otp_field with static feedback" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="check is-valid" id="user_terms" name="user[terms]" required="required" type="checkbox" value="1" />
        <div class="form-field-content">
          <label class="required" for="user_terms">Terms</label>
          <div class="invalid-feedback">You must agree before submitting.</div>
        </div>
      </div>
      <div class="form-field mb-3">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-control" id="user_status" name="user[status]" required="required">
          <option value="">Choose...</option>
          <option value="1">One</option>
        </select>
        <div class="invalid-feedback">Please select a status.</div>
      </div>
      <div class="form-field mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="otp is-valid" data-bs-otp="">
          <input autocomplete="one-time-code" class="otp-input is-valid" id="user_misc" maxlength="6" name="user[misc]" type="text" />
        </div>
        <div class="valid-feedback">Code accepted.</div>
      </div>
    HTML
    actual = @builder.check_box(:terms, required: true, valid: true, invalid_feedback: "You must agree before submitting.") +
             @builder.select(:status, [["One", 1]], { prompt: "Choose...", invalid_feedback: "Please select a status." },
                             { required: true }) +
             @builder.otp_field(:misc, valid: true, valid_feedback: "Code accepted.")
    assert_equivalent_html expected, actual
  end
end
