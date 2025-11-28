# frozen_string_literal: true

require_relative "test_helper"

class BootstrapCheckboxTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  test "check_box is wrapped correctly" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" extra="extra arg" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", extra: "extra arg")
  end

  test "check_box empty label" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">&#8203;</label>
      </div>
    HTML
    # &#8203; is a zero-width space.
    assert_equivalent_html expected, @builder.check_box(:terms, label: "&#8203;".html_safe)
  end

  test "disabled check_box has proper wrapper classes" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" disabled="disabled" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" disabled="disabled" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", disabled: true)
  end

  test "check_box label allows html" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the <a href="#">terms</a>
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: 'I agree to the <a href="#">terms</a>'.html_safe)
  end

  test "check_box accepts a block to define the label" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms) { "I agree to the terms" }
  end

  test "check_box accepts a custom label class" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label btn" for="user_terms">
          Terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label_class: "btn")
  end

  test "check_box 'id' attribute is used to specify label 'for' attribute" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="custom_id" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="custom_id">
          Terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, id: "custom_id")
  end

  test "check_box responds to checked_value and unchecked_value arguments" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="no" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="yes" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, { label: "I agree to the terms" }, "yes", "no")
  end

  test "inline checkboxes" do
    expected = <<~HTML
      <div class="form-check form-check-inline mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", inline: true)
  end

  test "inline checkboxes from form layout" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user row row-cols-auto g-3 align-items-center" id="new_user" method="post">
        <div class="col">
          <div class="form-check form-check-inline">
            <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
            <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_terms">I agree to the terms</label>
          </div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user, layout: :inline) do |f|
      f.check_box(:terms, label: "I agree to the terms")
    end
    assert_equivalent_html expected, actual
  end

  test "disabled inline check_box" do
    expected = <<~HTML
      <div class="form-check form-check-inline mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" disabled="disabled" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" disabled="disabled" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", inline: true,
                                                                disabled: true)
  end

  test "inline checkboxes with custom label class" do
    expected = <<~HTML
      <div class="form-check form-check-inline mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label btn" for="user_terms">
          Terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, inline: true, label_class: "btn")
  end

  test "check_box skip label" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input position-static" id="user_terms" name="user[terms]" type="checkbox" value="1" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", skip_label: true)
  end

  test "check_box hide label" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input position-static" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label visually-hidden" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", hide_label: true)
  end

  test "check_box renders error when asked" do
    @user.errors.add(:terms, "You must accept the terms.")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          <div class="form-check mb-3">
          <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input is-invalid" id="user_terms" aria-labelledby="user_terms_feedback" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">
            I agree to the terms
          </label>
          <div class="invalid-feedback" id="user_terms_feedback">You must accept the terms.</div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user) do |f|
      f.check_box(:terms, label: "I agree to the terms", error_message: true)
    end
    assert_equivalent_html expected, actual
  end

  test "check_box renders error when asked with specified id:" do
    @user.errors.add(:terms, "You must accept the terms.")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          <div class="form-check mb-3">
          <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input is-invalid" id="custom-id" aria-labelledby="custom-id_feedback" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="custom-id">
            I agree to the terms
          </label>
          <div class="invalid-feedback" id="custom-id_feedback">You must accept the terms.</div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user) do |f|
      f.check_box(:terms, label: "I agree to the terms", error_message: true, id: "custom-id")
    end
    assert_equivalent_html expected, actual
  end

  test "check box with custom wrapper class" do
    expected = <<~HTML
      <div class="form-check mb-3 custom-class">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", wrapper_class: "custom-class")
  end

  test "check box with custom wrapper class false" do
    expected = <<~HTML
      <div class="form-check">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", wrapper_class: false)
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", wrapper: { class: false })
  end

  test "inline check box with custom wrapper class" do
    expected = <<~HTML
      <div class="form-check form-check-inline mb-3 custom-class">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", inline: true,
                                                                wrapper_class: "custom-class")
  end

  test "a required checkbox" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" required="required" type="checkbox" value="1"/>
        <label class="form-check-label required" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", required: true)
  end

  test "a required attribute as checkbox" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[email]" type="hidden" value="0"/>
        <input class="form-check-input" id="user_email" name="user[email]" required="required" type="checkbox" value="1"/>
        <label class="form-check-label" for="user_email">Email</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:email, label: "Email")
  end

  test "an attribute with required and if is not marked as required" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[status]" type="hidden" value="0"/>
        <input class="form-check-input" id="user_status" name="user[status]" type="checkbox" value="1"/>
        <label class="form-check-label" for="user_status">Status</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:status, label: "Status")
  end

  test "an attribute with presence validator and unless is not marked as required" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[misc]" type="hidden" value="0"/>
        <input class="form-check-input" id="user_misc" name="user[misc]" type="checkbox" value="1"/>
        <label class="form-check-label" for="user_misc">Misc</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:misc)
  end

  if Rails::VERSION::MAJOR >= 8
    test "checkbox alias works" do
      expected = <<~HTML
        <div class="form-check mb-3">
          <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" extra="extra arg" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">
            I agree to the terms
          </label>
        </div>
      HTML
      assert_equivalent_html expected, @builder.checkbox(:terms, label: "I agree to the terms", extra: "extra arg")
    end
  end
end
