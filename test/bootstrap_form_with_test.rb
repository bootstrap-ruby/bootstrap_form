require_relative 'test_helper'

# Tests for `form_with`.
# Do all the tests for `bootstrap_form_for` and `bootstrap_form_tag`, but with
# `bootstrap_form_with`.
if ::Rails::VERSION::STRING >= '5.1'

  class BootstrapFormWithTest < ActionView::TestCase
    include BootstrapForm::Helper

    def setup
      setup_test_fixture
    end

    # This set of tests simply mirrors the tests in `bootstrap_form_test.rb`, but using `form_with`
    # instead of `form_for` or `form_tag`.
    test "form_with default-style forms" do
      # https://m.patrikonrails.com/rails-5-1s-form-with-vs-old-form-helpers-3a5f72a8c78a confirms
      # that `form_with` doesn't add the class and id like `form_for` did.
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(model: @user) { |f| nil }
    end

    test "form_with inline-style forms" do
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" class="form-inline" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(model: @user, layout: :inline) { |f| nil }
    end

    test "form_with horizontal-style forms" do
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group row">
            <label class="col-sm-2 required" for="user_email">Email</label>
            <div class="col-sm-10">
              <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
            </div>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(model: @user, layout: :horizontal) { |f| f.email_field :email }
    end

    test "form_with existing styles aren't clobbered when specifying a form style" do
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" class="my-style" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group row">
            <label class="col-sm-2 required" for="user_email">Email</label>
            <div class="col-sm-10">
              <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
            </div>
          </div>
        </form>
      HTML
      # puts Nokogiri::XML(expected)
      # puts Nokogiri::XML(bootstrap_form_with(model: @user, layout: :horizontal, html: { class: "my-style" }) { |f| f.email_field :email })
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(model: @user, layout: :horizontal, html: { class: "my-style" }) { |f| f.email_field :email }
    end

    test "form_with given role attribute should not be covered by default role attribute" do
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="not-a-form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(model: @user, html: { role: 'not-a-form'}) {|f| nil}
    end

    test "form_with bootstrap_form_tag acts like a form tag" do
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label for="email">Your Email</label>
            <input class="form-control" id="email" name="email" type="text" />
          </div>
        </form>
      HTML
      # puts bootstrap_form_with(url: '/users') { |f| f.text_field :email, label: "Your Email" }
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(url: '/users') { |f| f.text_field :email, label: "Your Email" }
    end

    # Make sure if ID is specified, that for is specified using ID.
    test "form_with bootstrap_form_tag does not clobber custom options" do
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label for="ID">Email</label>
            <input class="form-control" id="ID" name="NAME" type="text" />
          </div>
        </form>
      HTML
      assert_equivalent_xml expected, bootstrap_form_with(url: '/users') { |f| f.text_field :email, name: 'NAME', id: "ID" }
    end

    test "form_with bootstrap_form_tag allows an empty name for checkboxes" do
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-check">
            <label class="form-check-label" for="misc">
              <input name="misc" type="hidden" value="0" />
              <input class="form-check-input" id="misc" name="misc" type="checkbox" value="1" /> Misc
            </label>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(url: '/users') { |f| f.check_box :misc }
    end

    test "form_with errors display correctly and inline_errors are turned off by default when label_errors is true" do
      @user.email = nil
      @user.valid?

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label class="required" for="user_email">
              Email can&#39;t be blank, is too short (minimum is 5 characters)
            </label>
            <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(model: @user, label_errors: true) { |f| f.text_field :email }
    end

    test "form_with errors display correctly and inline_errors can also be on when label_errors is true" do
      @user.email = nil
      @user.valid?

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label class="required" for="user_email">
              Email can&#39;t be blank, is too short (minimum is 5 characters)
            </label>
            <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
            <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(model: @user, label_errors: true, inline_errors: true) { |f| f.text_field :email }
    end

    test "form_with label error messages use humanized attribute names" do
      I18n.backend.store_translations(:en, {activerecord: {attributes: {user: {email: 'Your e-mail address'}}}})

      @user.email = nil
      @user.valid?

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label class="required" for="user_email">Your e-mail address can&#39;t be blank, is too short (minimum is 5 characters)</label>
            <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
            <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(model: @user, local: true, label_errors: true, inline_errors: true) { |f| f.text_field :email }

      I18n.backend.store_translations(:en, {activerecord: {attributes: {user: {email: nil}}}})
    end

    test "form_with alert message is wrapped correctly" do
      @user.email = nil
      @user.valid?
      expected = <<-HTML.strip_heredoc
        <div class="alert alert-danger">
          <p>Please fix the following errors:</p>
          <ul class="rails-bootstrap-forms-error-summary">
            <li>Email can&#39;t be blank</li>
            <li>Email is too short (minimum is 5 characters)</li>
            <li>Terms must be accepted</li>
          </ul>
        </div>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), @builder.alert_message('Please fix the following errors:')
    end

    test "form_with changing the class name for the alert message" do
      @user.email = nil
      @user.valid?
      expected = <<-HTML.strip_heredoc
        <div class="my-css-class">
          <p>Please fix the following errors:</p>
          <ul class="rails-bootstrap-forms-error-summary">
            <li>Email can&#39;t be blank</li>
            <li>Email is too short (minimum is 5 characters)</li>
            <li>Terms must be accepted</li>
          </ul>
        </div>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), @builder.alert_message('Please fix the following errors:', class: 'my-css-class')
    end

    test "form_with alert_message contains the error summary when inline_errors are turned off" do
      @user.email = nil
      @user.valid?

      output = bootstrap_form_with(model: @user, inline_errors: false) do |f|
        f.alert_message('Please fix the following errors:')
      end

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="alert alert-danger">
            <p>Please fix the following errors:</p>
            <ul class="rails-bootstrap-forms-error-summary">
              <li>Email can&#39;t be blank</li>
              <li>Email is too short (minimum is 5 characters)</li>
              <li>Terms must be accepted</li>
            </ul>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), output
    end

    test "form_with alert_message allows the error_summary to be turned off" do
      @user.email = nil
      @user.valid?

      output = bootstrap_form_with(model: @user, inline_errors: false) do |f|
        f.alert_message('Please fix the following errors:', error_summary: false)
      end

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="alert alert-danger">
            <p>Please fix the following errors:</p>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), output
    end

    test "form_with alert_message allows the error_summary to be turned on with inline_errors also turned on" do
      @user.email = nil
      @user.valid?

      output = bootstrap_form_with(model: @user, inline_errors: true) do |f|
        f.alert_message('Please fix the following errors:', error_summary: true)
      end

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="alert alert-danger">
            <p>Please fix the following errors:</p>
            <ul class="rails-bootstrap-forms-error-summary">
              <li>Email can&#39;t be blank</li>
              <li>Email is too short (minimum is 5 characters)</li>
              <li>Terms must be accepted</li>
            </ul>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), output
    end

    test "form_with error_summary returns an unordered list of errors" do
      @user.email = nil
      @user.valid?

      expected = <<-HTML.strip_heredoc
        <ul class="rails-bootstrap-forms-error-summary">
          <li>Email can&#39;t be blank</li>
          <li>Email is too short (minimum is 5 characters)</li>
          <li>Terms must be accepted</li>
        </ul>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), @builder.error_summary
    end

    test 'errors_on renders the errors for a specific attribute when invalid' do
      @user.email = nil
      @user.valid?

      expected = <<-HTML.strip_heredoc
        <div class="alert alert-danger">Email can&#39;t be blank, Email is too short (minimum is 5 characters)</div>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), @builder.errors_on(:email)
    end

    test "form_with custom label width for horizontal forms" do
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group row">
            <label class="col-sm-1 required" for="user_email">Email</label>
            <div class="col-sm-10">
              <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
            </div>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(model: @user, layout: :horizontal) { |f| f.email_field :email, label_col: 'col-sm-1' }
    end

    test "form_with offset for form group without label respects label width for horizontal forms" do
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group row">
            <div class="col-md-10 col-md-offset-2">
              <input class="btn btn-secondary" name="commit" type="submit" value="Create User" />
            </div>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(model: @user, layout: :horizontal, label_col: 'col-md-2', control_col: 'col-md-10') { |f| f.form_group { f.submit } }
    end

    test "form_with custom input width for horizontal forms" do
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group row">
            <label class="col-sm-2 required" for="user_email">Email</label>
            <div class="col-sm-5">
              <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
            </div>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), bootstrap_form_with(model: @user, layout: :horizontal) { |f| f.email_field :email, control_col: 'col-sm-5' }
    end

    test "form_with the field contains the error and is not wrapped in div.field_with_errors when bootstrap_form_for is used" do
      @user.email = nil
      @user.valid?

      output = bootstrap_form_with(model: @user) do |f|
        f.text_field(:email, help: 'This is required')
      end

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label class="required" for="user_email">Email</label>
            <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
            <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), output
    end

    test "form_with the field is wrapped with div.field_with_errors when form_with is used" do
      @user.email = nil
      @user.valid?

      output = form_with(model: @user, builder: BootstrapForm::FormBuilder) do |f|
        f.text_field(:email, help: 'This is required')
      end

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <div class="field_with_errors">
              <label class="required" for="user_email">Email</label>
            </div>
            <div class="field_with_errors">
              <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
            </div>
            <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
          </div>
        </form>
        HTML
      # puts "Rails: #{ActionView::Helpers::FormBuilder.new(:user, @user, self, skip_default_ids: true).label(:email)}"
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), output
    end

    test "form_with help is preserved when inline_errors: false is passed to bootstrap_form_for" do
      @user.email = nil
      @user.valid?

      output = bootstrap_form_with(model: @user, inline_errors: false) do |f|
        f.text_field(:email, help: 'This is required')
      end

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form" data-remote="true">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label class="required" for="user_email">Email</label>
            <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
            <small class="form-text text-muted">This is required</small>
          </div>
        </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), output
    end

    test "form_with allows the form object to be nil" do
      # Simulate how the builder would be called from `form_with`.
      builder = BootstrapForm::FormBuilder.new :other_model, nil, self, { skip_default_ids: true }
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="other_model_email">Email</label>
          <input class="form-control" name="other_model[email]" type="text" />
        </div>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), builder.text_field(:email)
    end

    test 'errors_on hide attribute name in message' do
      @user.email = nil
      @user.valid?

      expected = <<-HTML.strip_heredoc
        <div class="alert alert-danger">can&#39;t be blank, is too short (minimum is 5 characters)</div>
      HTML

      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), @builder.errors_on(:email, hide_attribute_name: true)
    end
    # End of the tests that mirror `bootstrap_form_test`.
  end
end
