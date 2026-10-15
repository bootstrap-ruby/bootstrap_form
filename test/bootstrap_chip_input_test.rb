# frozen_string_literal: true

require_relative "test_helper"

class BootstrapChipInputTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  DISMISS = BootstrapForm::Inputs::ChipInput::DISMISS_ICON

  test "chip_input renders existing values as dismissible chips" do
    @user.preferences = %w[JavaScript TypeScript]
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_preferences">Preferences</label>
        <div class="chip-input" data-bs-chips="">
          <span class="chip" data-bs-chip-value="JavaScript">JavaScript<button aria-label="Remove" class="chip-dismiss" type="button">#{DISMISS}</button></span>
          <span class="chip" data-bs-chip-value="TypeScript">TypeScript<button aria-label="Remove" class="chip-dismiss" type="button">#{DISMISS}</button></span>
          <input class="form-ghost" id="user_preferences" placeholder="Add more…" type="text">
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.chip_input(:preferences, placeholder: "Add more…")
  end

  test "chip_input with options, explicit values and a comma-separated string" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_misc">Skills</label>
        <div class="chip-input theme-primary" data-bs-chips="" data-bs-separator=";" data-bs-max-chips="5" data-bs-dismissible="false">
          <span class="chip" data-bs-chip-value="Ruby">Ruby</span>
          <span class="chip" data-bs-chip-value="Rails">Rails</span>
          <input aria-describedby="user_misc_help" class="form-ghost" id="user_misc" type="text">
        </div>
        <small class="form-text" id="user_misc_help">Press Enter to add a skill.</small>
      </div>
    HTML
    actual = @builder.chip_input(:misc, label: "Skills", values: "Ruby; Rails", help: "Press Enter to add a skill.",
                                        chips: { class: "theme-primary", separator: ";", max_chips: 5, dismissible: false })
    assert_equivalent_html expected, actual
  end

  test "chip_input with error and namespace" do
    @user.errors.add(:misc, "is invalid")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="ns_new_user" method="post">
        <div class="form-field mb-3">
          <label class="form-label" for="ns_user_misc">Misc</label>
          <div class="chip-input" data-bs-chips="">
            <input aria-describedby="user_misc_feedback" class="form-ghost is-invalid" id="ns_user_misc" type="text">
          </div>
          <div class="invalid-feedback" id="user_misc_feedback">is invalid</div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user, namespace: "ns") { |f| f.chip_input(:misc) }
    assert_equivalent_html expected, actual
  end
end
