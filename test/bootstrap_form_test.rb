# frozen_string_literal: true

require_relative "test_helper"

class BootstrapFormTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup do
    setup_test_fixture
    Rails.application.config.bootstrap_form.group_around_collections = true
  end

  teardown do
    Rails.application.config.bootstrap_form.group_around_collections = false
  end

  test "default-style forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |_f| nil }
  end

  test "default-style form fields layout horizontal" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
        <div class="form-check mb-3">
          <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">I agree to the terms</label>
        </div>
        <div aria-labelledby="user_misc" class="mb-3 row" role="group">
          <div class="col-form-label col-sm-2 pt-0" id="user_misc">Misc</div>
          <div class="col-sm-10">
            <div class="form-check">
              <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
              <label class="form-check-label" for="user_misc_1">Foo</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
              <label class="form-check-label" for="user_misc_2">Bar</label>
            </div>
          </div>
        </div>
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2" for="user_status">Status</label>
          <div class="col-sm-10">
            <select class="form-select" id="user_status" name="user[status]">
              <option value="1">activated</option>
              <option value="2">blocked</option>
            </select>
          </div>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user) do |f|
      concat(f.email_field(:email, layout: :horizontal))
      concat(f.check_box(:terms, label: "I agree to the terms"))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :horizontal))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]], layout: :horizontal))
    end

    assert_equivalent_html expected, actual
    # See the rendered output at: https://www.bootply.com/S2WFzEYChf
  end

  test "default-style form fields layout inline" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 col-auto g-3">
          <label class="form-label me-sm-2 required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="form-check form-check-inline mb-3">
          <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">I agree to the terms</label>
        </div>
        <div aria-labelledby="user_misc" class="mb-3 col-auto g-3" role="group">
          <div class="form-check form-check-inline ps-0" id="user_misc">Misc</div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1">Foo</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2">Bar</label>
          </div>
        </div>
        <div class="mb-3 col-auto g-3">
          <label class="form-label me-sm-2" for="user_status">Status</label>
          <select class="form-select" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user) do |f|
      concat(f.email_field(:email, layout: :inline))
      concat(f.check_box(:terms, label: "I agree to the terms", inline: true))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :inline))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]], layout: :inline))
    end

    assert_equivalent_html expected, actual
    # See the rendered output at: https://www.bootply.com/fH5sF4fcju
    # Note that the baseline of the label text to the left of the two radio buttons
    # isn't aligned with the text of the radio button labels.
    # TODO: Align baseline better.
  end

  test "default-style forms bootstrap_form_with Rails 7.1+" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" method="post">
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_with(model: @user) { |_f| nil }
  end

  test "inline-style forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user row row-cols-auto g-3 align-items-center" id="new_user" method="post">
        <div class="col">
          <label class="form-label me-sm-2 required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="col">
          <div class="form-check form-check-inline">
            <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
            <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_terms">I agree to the terms</label>
          </div>
        </div>
        <div aria-labelledby="user_misc" class="col" role="group">
          <div class="form-check form-check-inline ps-0" id="user_misc">Misc</div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1">Foo</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2">Bar</label>
          </div>
        </div>
        <div class="col">
          <label class="form-label me-sm-2" for="user_status">Status</label>
          <select class="form-select" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user, layout: :inline) do |f|
      concat(f.email_field(:email))
      concat(f.check_box(:terms, label: "I agree to the terms"))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]]))
    end

    assert_equivalent_html expected, actual
  end

  test "horizontal-style forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
        <div class="mb-3 row">
          <div class="col-sm-10 offset-sm-2">
            <div class="form-check">
              <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
              <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
              <label class="form-check-label" for="user_terms">I agree to the terms</label>
            </div>
          </div>
        </div>
        <div aria-labelledby="user_misc" class="mb-3 row" role="group">
          <div class="col-form-label col-sm-2 pt-0" id="user_misc">Misc</div>
          <div class="col-sm-10">
            <div class="form-check">
              <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
              <label class="form-check-label" for="user_misc_1">Foo</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
              <label class="form-check-label" for="user_misc_2">Bar</label>
            </div>
          </div>
        </div>
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2" for="user_status">Status</label>
          <div class="col-sm-10">
            <select class="form-select" id="user_status" name="user[status]">
              <option value="1">activated</option>
              <option value="2">blocked</option>
            </select>
          </div>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user, layout: :horizontal) do |f|
      concat(f.email_field(:email))
      concat(f.check_box(:terms, label: "I agree to the terms"))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]]))
    end

    assert_equivalent_html expected, actual
  end

  test "horizontal-style form fields layout vertical" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="mb-3 row">
          <div class="col-sm-10 offset-sm-2">
            <div class="form-check">
              <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
              <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
              <label class="form-check-label" for="user_terms">I agree to the terms</label>
            </div>
          </div>
        </div>
        <div aria-labelledby="user_misc" class="mb-3" role="group">
          <div class="form-label" id="user_misc">Misc</div>
          <div class="form-check">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1">Foo</label>
          </div>
          <div class="form-check">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2">Bar</label>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label" for="user_status">Status</label>
          <select class="form-select" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user, layout: :horizontal) do |f|
      concat(f.email_field(:email, layout: :vertical))
      concat(f.check_box(:terms, label: "I agree to the terms"))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :vertical))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]], layout: :vertical))
    end

    assert_equivalent_html expected, actual
    # See the rendered output at: https://www.bootply.com/4f23be1nLn
  end

  test "horizontal-style form fields layout inline" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 col-auto g-3">
          <label class="form-label me-sm-2 required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="mb-3 row">
          <div class="col-sm-10 offset-sm-2">
            <div class="form-check form-check-inline">
              <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
              <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
              <label class="form-check-label" for="user_terms">I agree to the terms</label>
            </div>
          </div>
        </div>
        <div aria-labelledby="user_misc" class="mb-3 col-auto g-3" role="group">
          <div class="form-check form-check-inline ps-0" id="user_misc">Misc</div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1">Foo</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2">Bar</label>
          </div>
        </div>
        <div class="mb-3 col-auto g-3">
          <label class="form-label me-sm-2" for="user_status">Status</label>
          <select class="form-select" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user, layout: :horizontal) do |f|
      concat(f.email_field(:email, layout: :inline))
      concat(f.check_box(:terms, label: "I agree to the terms", inline: true))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :inline))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]], layout: :inline))
    end

    assert_equivalent_html expected, actual
    # See the rendered output here: https://www.bootply.com/Qby9FC9d3u#
  end

  test "existing styles aren't clobbered when specifying a form style" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="my-style" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, layout: :horizontal, html: { class: "my-style" }) { |f| f.email_field :email }
  end

  class WarningFormBuilder < BootstrapForm::FormBuilder
    cattr_accessor :instance
    attr_reader :warnings

    def self.new(...)
      self.instance = super
    end

    def warn(message, ...)
      @warnings ||= []
      @warnings << message
    end
  end

  test "old default layout gives warnings" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input class="form-control" id="user_email" name="user[email]" required="required" type="email" value="steve@example.com">
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, builder: WarningFormBuilder, layout: :default) { |f|
                             f.email_field :email, layout: :default
                           }
    assert_equal [
      "Layout `:default` is deprecated, use `:vertical` instead.",
      "Layout `:default` is deprecated, use `:vertical` instead."
    ], WarningFormBuilder.instance.warnings
  end

  test "given role attribute should not be covered by default role attribute" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="not-a-form">
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user, html: { role: "not-a-form" }) { |_f| nil }
  end

  test "allows to set blank default form attributes via configuration" do
    BootstrapForm.config.stubs(:default_form_attributes).returns({})
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |_f| nil }
  end

  test "allows to set custom default form attributes via configuration" do
    BootstrapForm.config.stubs(:default_form_attributes).returns(foo: "bar")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" foo="bar" id="new_user" method="post">
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |_f| nil }
  end

  test "bootstrap_form_tag acts like a form tag" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" method="post">
        <div class="mb-3">
          <label class="form-label" for="email">Your Email</label>
          <input class="form-control" id="email" name="email" type="text" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_tag(url: "/users") { |f| f.text_field :email, label: "Your Email" }
  end

  test "bootstrap_form_for does not clobber custom options" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="ID">Email</label>
          <input required="required" class="form-control" id="ID" name="NAME" type="text" value="steve@example.com" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |f| f.text_field :email, name: "NAME", id: "ID" }
  end

  test "bootstrap_form_tag does not clobber custom options" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" method="post">
        <div class="mb-3">
          <label class="form-label" for="ID">Email</label>
          <input class="form-control" id="ID" name="NAME" type="text" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_tag(url: "/users") { |f| f.text_field :email, name: "NAME", id: "ID" }
  end

  test "bootstrap_form_tag allows an empty name for checkboxes" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" method="post">
        <div class="form-check mb-3">
          <input #{autocomplete_attr} name="misc" type="hidden" value="0" />
          <input class="form-check-input" id="misc" name="misc" type="checkbox" value="1" />
          <label class="form-check-label" for="misc"> Misc</label>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_tag(url: "/users") { |f| f.check_box :misc }
  end

  test "errors display correctly and inline_errors are turned off by default when label_errors is true" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required text-danger" for="user_email" id="user_email_feedback">Email can't be blank, is too short (minimum is 5 characters)</label>
          <input required="required" class="form-control is-invalid" id="user_email"  aria-labelledby="user_email_feedback" name="user[email]" type="text" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user, label_errors: true) { |f| f.text_field :email }
  end

  test "errors display correctly and inline_errors can also be on when label_errors is true" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required text-danger" for="user_email" id="user_email_feedback">Email can't be blank, is too short (minimum is 5 characters)</label>
          <input required="required" class="form-control is-invalid" id="user_email"  aria-labelledby="user_email_feedback" name="user[email]" type="text" />
          <div class="invalid-feedback" id="user_email_feedback">can't be blank, is too short (minimum is 5 characters)</span>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user, label_errors: true, inline_errors: true) { |f| f.text_field :email }
  end

  test "label error messages use humanized attribute names" do
    I18n.backend.store_translations(:en, activerecord: { attributes: { user: { email: "Your e-mail address" } } })

    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required text-danger" for="user_email"id="user_email_feedback">Your e-mail address can't be blank, is too short (minimum is 5 characters)</label>
          <input required="required" class="form-control is-invalid" id="user_email"  aria-labelledby="user_email_feedback" name="user[email]" type="text" />
          <div class="invalid-feedback" id="user_email_feedback">can't be blank, is too short (minimum is 5 characters)</div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user, label_errors: true, inline_errors: true) { |f| f.text_field :email }
  ensure
    I18n.backend.store_translations(:en, activerecord: { attributes: { user: { email: nil } } })
  end

  test "alert message is wrapped correctly" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <div class="alert alert-danger">
        <p>Please fix the following errors:</p>
        <ul class="rails-bootstrap-forms-error-summary">
          <li>Email can't be blank</li>
          <li>Email is too short (minimum is 5 characters)</li>
          <li>Terms must be accepted</li>
        </ul>
      </div>
    HTML
    assert_equivalent_html expected, @builder.alert_message("Please fix the following errors:")
  end

  test "changing the class name for the alert message" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <div class="my-css-class">
        <p>Please fix the following errors:</p>
        <ul class="rails-bootstrap-forms-error-summary">
          <li>Email can't be blank</li>
          <li>Email is too short (minimum is 5 characters)</li>
          <li>Terms must be accepted</li>
        </ul>
      </div>
    HTML
    assert_equivalent_html expected, @builder.alert_message("Please fix the following errors:", class: "my-css-class")
  end

  test "alert_message contains the error summary when inline_errors are turned off" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.alert_message("Please fix the following errors:")
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="alert alert-danger">
          <p>Please fix the following errors:</p>
          <ul class="rails-bootstrap-forms-error-summary">
            <li>Email can't be blank</li>
            <li>Email is too short (minimum is 5 characters)</li>
            <li>Terms must be accepted</li>
          </ul>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "alert_message allows the error_summary to be turned off" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.alert_message("Please fix the following errors:", error_summary: false)
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="alert alert-danger">Please fix the following errors:</div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "alert_message allows the error_summary to be turned on with inline_errors also turned on" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: true) do |f|
      f.alert_message("Please fix the following errors:", error_summary: true)
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="alert alert-danger">
          <p>Please fix the following errors:</p>
          <ul class="rails-bootstrap-forms-error-summary">
            <li>Email can't be blank</li>
            <li>Email is too short (minimum is 5 characters)</li>
            <li>Terms must be accepted</li>
          </ul>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "error_summary returns an unordered list of errors" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <ul class="rails-bootstrap-forms-error-summary">
        <li>Email can't be blank</li>
        <li>Email is too short (minimum is 5 characters)</li>
        <li>Terms must be accepted</li>
      </ul>
    HTML
    assert_equivalent_html expected, @builder.error_summary
  end

  test "error_summary returns nothing if no errors" do
    @user.terms = true
    assert @user.valid?

    assert_nil @builder.error_summary
  end

  test "errors_on renders the errors for a specific attribute when invalid" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <div class="invalid-feedback" id="user_email_feedback">Email can't be blank, Email is too short (minimum is 5 characters)</div>
    HTML
    assert_equivalent_html expected, @builder.errors_on(:email)
  end

  test "custom label width for horizontal forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-1 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, label_col: "col-sm-1" }
  end

  test "offset for form group without label respects label width for horizontal forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <div class="col-md-10 offset-md-2">
            <input class="btn btn-secondary" name="commit" type="submit" value="Create User" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, layout: :horizontal, label_col: "col-md-2",
                                                     control_col: "col-md-10") { |f| f.form_group { f.submit } }
  end

  test "offset for form group without label respects multiple label widths for horizontal forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <div class="col-sm-8 col-md-10 offset-sm-4 offset-md-2">
            <input class="btn btn-secondary" name="commit" type="submit" value="Create User" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, layout: :horizontal, label_col: %w[col-sm-4 col-md-2],
                                                     control_col: "col-sm-8 col-md-10") { |f| f.form_group { f.submit } }
  end

  test "custom input width for horizontal forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-5">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, control_col: "col-sm-5" }
  end

  test "additional input col class" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-10 custom-class">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user,
                                layout: :horizontal) { |f| f.email_field :email, add_control_col_class: "custom-class" }
    assert_equivalent_html expected, actual
  end

  test "the field contains the error and is not wrapped in div.field_with_errors when bootstrap_form_for is used" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user) do |f|
      f.text_field(:email, help: "This is required")
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input required="required" class="form-control is-invalid" id="user_email"  aria-labelledby="user_email_feedback" name="user[email]" type="text" />
          <div class="invalid-feedback" id="user_email_feedback">can't be blank, is too short (minimum is 5 characters)</div>
          <small class="form-text text-muted">This is required</small>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "the field is wrapped with div.field_with_errors when form_for is used" do
    @user.email = nil
    assert @user.invalid?

    output = form_for(@user, builder: BootstrapForm::FormBuilder) do |f|
      f.text_field(:email, help: "This is required")
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <div class="field_with_errors">
            <label class="form-label required" for="user_email">Email</label>
          </div>
          <div class="field_with_errors">
            <input required="required" class="form-control is-invalid" id="user_email"  aria-labelledby="user_email_feedback" name="user[email]" type="text" />
          </div>
          <div class="invalid-feedback" id="user_email_feedback">can't be blank, is too short (minimum is 5 characters)</div>
          <small class="form-text text-muted">This is required</small>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "help is preserved when inline_errors: false is passed to bootstrap_form_for" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.text_field(:email, help: "This is required")
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input required="required" class="form-control is-invalid" id="user_email"  aria-labelledby="user_email_feedback" name="user[email]" type="text" />
          <small class="form-text text-muted">This is required</small>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "help translations do not escape HTML when _html is appended to the name" do
    I18n.backend.store_translations(:en, activerecord: { help: { user: { email_html: "This is <strong>useful</strong> help" } } })

    output = bootstrap_form_for(@user) do |f|
      f.text_field(:email)
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
          <small class="form-text text-muted">This is <strong>useful</strong> help</small>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  ensure
    I18n.backend.store_translations(:en, activerecord: { help: { user: { email_html: nil } } })
  end

  test "allows the form object to be nil" do
    builder = BootstrapForm::FormBuilder.new :other_model, nil, self, {}
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="other_model_email">Email</label>
        <input class="form-control" id="other_model_email" name="other_model[email]" type="text" />
      </div>
    HTML
    assert_equivalent_html expected, builder.text_field(:email)
  end

  test "errors_on hide attribute name in message" do
    @user.email = nil
    assert @user.invalid?

    expected = '<div class="invalid-feedback" id="user_email_feedback">can\'t be blank, is too short (minimum is 5 characters)</div>'

    assert_equivalent_html expected, @builder.errors_on(:email, hide_attribute_name: true)
  end

  test "errors_on use custom CSS classes" do
    @user.email = nil
    assert @user.invalid?

    expected = '<div class="custom-error-class" id="user_email_feedback">Email can\'t be blank, Email is too short (minimum is 5 characters)</div>'

    assert_equivalent_html expected, @builder.errors_on(:email, custom_class: "custom-error-class")
  end
end

class LegacyBootstrapFormTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup do
    setup_test_fixture
    Rails.application.config.bootstrap_form.group_around_collections = false
  end

  teardown do
    Rails.application.config.bootstrap_form.group_around_collections = true
  end

  test "default-style forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |_f| nil }
  end

  test "default-style form fields layout horizontal" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
        <div class="form-check mb-3">
          <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">I agree to the terms</label>
        </div>
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 pt-0" for="user_misc">Misc</label>
          <div class="col-sm-10">
            <div class="form-check">
              <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
              <label class="form-check-label" for="user_misc_1">Foo</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
              <label class="form-check-label" for="user_misc_2">Bar</label>
            </div>
          </div>
        </div>
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2" for="user_status">Status</label>
          <div class="col-sm-10">
            <select class="form-select" id="user_status" name="user[status]">
              <option value="1">activated</option>
              <option value="2">blocked</option>
            </select>
          </div>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user) do |f|
      concat(f.email_field(:email, layout: :horizontal))
      concat(f.check_box(:terms, label: "I agree to the terms"))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :horizontal))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]], layout: :horizontal))
    end

    assert_equivalent_html expected, actual
    # See the rendered output at: https://www.bootply.com/S2WFzEYChf
  end

  test "default-style form fields layout inline" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 col-auto g-3">
          <label class="form-label me-sm-2 required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="form-check form-check-inline mb-3">
          <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">I agree to the terms</label>
        </div>
        <div class="mb-3 col-auto g-3">
          <label class="form-check form-check-inline ps-0" for="user_misc">Misc</label>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1">Foo</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2">Bar</label>
          </div>
        </div>
        <div class="mb-3 col-auto g-3">
          <label class="form-label me-sm-2" for="user_status">Status</label>
          <select class="form-select" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user) do |f|
      concat(f.email_field(:email, layout: :inline))
      concat(f.check_box(:terms, label: "I agree to the terms", inline: true))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :inline))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]], layout: :inline))
    end

    assert_equivalent_html expected, actual
    # See the rendered output at: https://www.bootply.com/fH5sF4fcju
    # Note that the baseline of the label text to the left of the two radio buttons
    # isn't aligned with the text of the radio button labels.
    # TODO: Align baseline better.
  end

  test "default-style forms bootstrap_form_with Rails 7.1+" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" method="post">
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_with(model: @user) { |_f| nil }
  end

  test "inline-style forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user row row-cols-auto g-3 align-items-center" id="new_user" method="post">
        <div class="col">
          <label class="form-label me-sm-2 required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="col">
          <div class="form-check form-check-inline">
            <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
            <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_terms">I agree to the terms</label>
          </div>
        </div>
        <div class="col">
          <label class="form-check form-check-inline ps-0" for="user_misc">Misc</label>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1">Foo</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2">Bar</label>
          </div>
        </div>
        <div class="col">
          <label class="form-label me-sm-2" for="user_status">Status</label>
          <select class="form-select" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user, layout: :inline) do |f|
      concat(f.email_field(:email))
      concat(f.check_box(:terms, label: "I agree to the terms"))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]]))
    end

    assert_equivalent_html expected, actual
  end

  class WarningFormBuilder < BootstrapForm::FormBuilder
    cattr_accessor :instance
    attr_reader :warnings

    def self.new(...)
      self.instance = super
    end

    def warn(message, ...)
      @warnings ||= []
      @warnings << message
    end
  end

  test "old default layout gives warnings" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input class="form-control" id="user_email" name="user[email]" required="required" type="email" value="steve@example.com">
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, builder: WarningFormBuilder, layout: :default) { |f|
                             f.email_field :email, layout: :default
                           }
    assert_equal [
      "Layout `:default` is deprecated, use `:vertical` instead.",
      "Layout `:default` is deprecated, use `:vertical` instead."
    ], WarningFormBuilder.instance.warnings
  end

  test "given role attribute should not be covered by default role attribute" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="not-a-form">
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user, html: { role: "not-a-form" }) { |_f| nil }
  end

  test "allows to set blank default form attributes via configuration" do
    BootstrapForm.config.stubs(:default_form_attributes).returns({})
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |_f| nil }
  end

  test "allows to set custom default form attributes via configuration" do
    BootstrapForm.config.stubs(:default_form_attributes).returns(foo: "bar")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" foo="bar" id="new_user" method="post">
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |_f| nil }
  end

  test "bootstrap_form_tag acts like a form tag" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" method="post">
        <div class="mb-3">
          <label class="form-label" for="email">Your Email</label>
          <input class="form-control" id="email" name="email" type="text" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_tag(url: "/users") { |f| f.text_field :email, label: "Your Email" }
  end

  test "bootstrap_form_for does not clobber custom options" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="ID">Email</label>
          <input required="required" class="form-control" id="ID" name="NAME" type="text" value="steve@example.com" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |f| f.text_field :email, name: "NAME", id: "ID" }
  end

  test "bootstrap_form_tag does not clobber custom options" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" method="post">
        <div class="mb-3">
          <label class="form-label" for="ID">Email</label>
          <input class="form-control" id="ID" name="NAME" type="text" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_tag(url: "/users") { |f| f.text_field :email, name: "NAME", id: "ID" }
  end

  test "bootstrap_form_tag allows an empty name for checkboxes" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" method="post">
        <div class="form-check mb-3">
          <input #{autocomplete_attr} name="misc" type="hidden" value="0" />
          <input class="form-check-input" id="misc" name="misc" type="checkbox" value="1" />
          <label class="form-check-label" for="misc"> Misc</label>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_tag(url: "/users") { |f| f.check_box :misc }
  end

  test "errors display correctly and inline_errors are turned off by default when label_errors is true" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required text-danger" for="user_email">Email can't be blank, is too short (minimum is 5 characters)</label>
          <input required="required" class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user, label_errors: true) { |f| f.text_field :email }
  end

  test "errors display correctly and inline_errors can also be on when label_errors is true" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required text-danger" for="user_email">Email can't be blank, is too short (minimum is 5 characters)</label>
          <input required="required" class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</span>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user, label_errors: true, inline_errors: true) { |f| f.text_field :email }
  end

  test "label error messages use humanized attribute names" do
    I18n.backend.store_translations(:en, activerecord: { attributes: { user: { email: "Your e-mail address" } } })

    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required text-danger" for="user_email">Your e-mail address can't be blank, is too short (minimum is 5 characters)</label>
          <input required="required" class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user, label_errors: true, inline_errors: true) { |f| f.text_field :email }
  ensure
    I18n.backend.store_translations(:en, activerecord: { attributes: { user: { email: nil } } })
  end

  test "alert message is wrapped correctly" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <div class="alert alert-danger">
        <p>Please fix the following errors:</p>
        <ul class="rails-bootstrap-forms-error-summary">
          <li>Email can't be blank</li>
          <li>Email is too short (minimum is 5 characters)</li>
          <li>Terms must be accepted</li>
        </ul>
      </div>
    HTML
    assert_equivalent_html expected, @builder.alert_message("Please fix the following errors:")
  end

  test "changing the class name for the alert message" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <div class="my-css-class">
        <p>Please fix the following errors:</p>
        <ul class="rails-bootstrap-forms-error-summary">
          <li>Email can't be blank</li>
          <li>Email is too short (minimum is 5 characters)</li>
          <li>Terms must be accepted</li>
        </ul>
      </div>
    HTML
    assert_equivalent_html expected, @builder.alert_message("Please fix the following errors:", class: "my-css-class")
  end

  test "alert_message contains the error summary when inline_errors are turned off" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.alert_message("Please fix the following errors:")
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="alert alert-danger">
          <p>Please fix the following errors:</p>
          <ul class="rails-bootstrap-forms-error-summary">
            <li>Email can't be blank</li>
            <li>Email is too short (minimum is 5 characters)</li>
            <li>Terms must be accepted</li>
          </ul>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "alert_message allows the error_summary to be turned off" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.alert_message("Please fix the following errors:", error_summary: false)
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="alert alert-danger">Please fix the following errors:</div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "alert_message allows the error_summary to be turned on with inline_errors also turned on" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: true) do |f|
      f.alert_message("Please fix the following errors:", error_summary: true)
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="alert alert-danger">
          <p>Please fix the following errors:</p>
          <ul class="rails-bootstrap-forms-error-summary">
            <li>Email can't be blank</li>
            <li>Email is too short (minimum is 5 characters)</li>
            <li>Terms must be accepted</li>
          </ul>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "error_summary returns an unordered list of errors" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <ul class="rails-bootstrap-forms-error-summary">
        <li>Email can't be blank</li>
        <li>Email is too short (minimum is 5 characters)</li>
        <li>Terms must be accepted</li>
      </ul>
    HTML
    assert_equivalent_html expected, @builder.error_summary
  end

  test "error_summary returns nothing if no errors" do
    @user.terms = true
    assert @user.valid?

    assert_nil @builder.error_summary
  end

  test "errors_on renders the errors for a specific attribute when invalid" do
    @user.email = nil
    assert @user.invalid?

    expected = <<~HTML
      <div class="invalid-feedback">Email can't be blank, Email is too short (minimum is 5 characters)</div>
    HTML
    assert_equivalent_html expected, @builder.errors_on(:email)
  end

  test "custom label width for horizontal forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-1 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, label_col: "col-sm-1" }
  end

  test "offset for form group without label respects label width for horizontal forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <div class="col-md-10 offset-md-2">
            <input class="btn btn-secondary" name="commit" type="submit" value="Create User" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, layout: :horizontal, label_col: "col-md-2",
                                                     control_col: "col-md-10") { |f| f.form_group { f.submit } }
  end

  test "offset for form group without label respects multiple label widths for horizontal forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <div class="col-sm-8 col-md-10 offset-sm-4 offset-md-2">
            <input class="btn btn-secondary" name="commit" type="submit" value="Create User" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, layout: :horizontal, label_col: %w[col-sm-4 col-md-2],
                                                     control_col: "col-sm-8 col-md-10") { |f| f.form_group { f.submit } }
  end

  test "custom input width for horizontal forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-5">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, control_col: "col-sm-5" }
  end

  test "additional input col class" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-10 custom-class">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user,
                                layout: :horizontal) { |f| f.email_field :email, add_control_col_class: "custom-class" }
    assert_equivalent_html expected, actual
  end

  test "the field contains the error and is not wrapped in div.field_with_errors when bootstrap_form_for is used" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user) do |f|
      f.text_field(:email, help: "This is required")
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input required="required" class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
          <small class="form-text text-muted">This is required</small>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "the field is wrapped with div.field_with_errors when form_for is used" do
    @user.email = nil
    assert @user.invalid?

    output = form_for(@user, builder: BootstrapForm::FormBuilder) do |f|
      f.text_field(:email, help: "This is required")
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <div class="field_with_errors">
            <label class="form-label required" for="user_email">Email</label>
          </div>
          <div class="field_with_errors">
            <input required="required" class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          </div>
          <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
          <small class="form-text text-muted">This is required</small>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "help is preserved when inline_errors: false is passed to bootstrap_form_for" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.text_field(:email, help: "This is required")
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input required="required" class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          <small class="form-text text-muted">This is required</small>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "help translations do not escape HTML when _html is appended to the name" do
    I18n.backend.store_translations(:en, activerecord: { help: { user: { email_html: "This is <strong>useful</strong> help" } } })

    output = bootstrap_form_for(@user) do |f|
      f.text_field(:email)
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
          <small class="form-text text-muted">This is <strong>useful</strong> help</small>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  ensure
    I18n.backend.store_translations(:en, activerecord: { help: { user: { email_html: nil } } })
  end

  test "allows the form object to be nil" do
    builder = BootstrapForm::FormBuilder.new :other_model, nil, self, {}
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="other_model_email">Email</label>
        <input class="form-control" id="other_model_email" name="other_model[email]" type="text" />
      </div>
    HTML
    assert_equivalent_html expected, builder.text_field(:email)
  end

  test "errors_on hide attribute name in message" do
    @user.email = nil
    assert @user.invalid?

    expected = '<div class="invalid-feedback">can\'t be blank, is too short (minimum is 5 characters)</div>'

    assert_equivalent_html expected, @builder.errors_on(:email, hide_attribute_name: true)
  end

  test "errors_on use custom CSS classes" do
    @user.email = nil
    assert @user.invalid?

    expected = '<div class="custom-error-class">Email can\'t be blank, Email is too short (minimum is 5 characters)</div>'

    assert_equivalent_html expected, @builder.errors_on(:email, custom_class: "custom-error-class")
  end

  test "horizontal-style forms" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
        <div class="mb-3 row">
          <div class="col-sm-10 offset-sm-2">
            <div class="form-check">
              <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
              <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
              <label class="form-check-label" for="user_terms">I agree to the terms</label>
            </div>
          </div>
        </div>
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 pt-0" for="user_misc">Misc</label>
          <div class="col-sm-10">
            <div class="form-check">
              <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
              <label class="form-check-label" for="user_misc_1">Foo</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
              <label class="form-check-label" for="user_misc_2">Bar</label>
            </div>
          </div>
        </div>
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2" for="user_status">Status</label>
          <div class="col-sm-10">
            <select class="form-select" id="user_status" name="user[status]">
              <option value="1">activated</option>
              <option value="2">blocked</option>
            </select>
          </div>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user, layout: :horizontal) do |f|
      concat(f.email_field(:email))
      concat(f.check_box(:terms, label: "I agree to the terms"))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]]))
    end

    assert_equivalent_html expected, actual
  end

  test "horizontal-style form fields layout vertical" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="mb-3 row">
          <div class="col-sm-10 offset-sm-2">
            <div class="form-check">
              <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
              <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
              <label class="form-check-label" for="user_terms">I agree to the terms</label>
            </div>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="form-check">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1">Foo</label>
          </div>
          <div class="form-check">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2">Bar</label>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label" for="user_status">Status</label>
          <select class="form-select" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user, layout: :horizontal) do |f|
      concat(f.email_field(:email, layout: :vertical))
      concat(f.check_box(:terms, label: "I agree to the terms"))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :vertical))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]], layout: :vertical))
    end

    assert_equivalent_html expected, actual
    # See the rendered output at: https://www.bootply.com/4f23be1nLn
  end

  test "horizontal-style form fields layout inline" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3 col-auto g-3">
          <label class="form-label me-sm-2 required" for="user_email">Email</label>
          <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="mb-3 row">
          <div class="col-sm-10 offset-sm-2">
            <div class="form-check form-check-inline">
              <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
              <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
              <label class="form-check-label" for="user_terms">I agree to the terms</label>
            </div>
          </div>
        </div>
        <div class="mb-3 col-auto g-3">
          <label class="form-check form-check-inline ps-0" for="user_misc">Misc</label>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1">Foo</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2">Bar</label>
          </div>
        </div>
        <div class="mb-3 col-auto g-3">
          <label class="form-label me-sm-2" for="user_status">Status</label>
          <select class="form-select" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    actual = bootstrap_form_for(@user, layout: :horizontal) do |f|
      concat(f.email_field(:email, layout: :inline))
      concat(f.check_box(:terms, label: "I agree to the terms", inline: true))
      concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :inline))
      concat(f.select(:status, [["activated", 1], ["blocked", 2]], layout: :inline))
    end

    assert_equivalent_html expected, actual
    # See the rendered output here: https://www.bootply.com/Qby9FC9d3u#
  end

  test "existing styles aren't clobbered when specifying a form style" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="my-style" id="new_user" method="post">
        <div class="mb-3 row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input required="required" class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user, layout: :horizontal, html: { class: "my-style" }) { |f| f.email_field :email }
  end
end
