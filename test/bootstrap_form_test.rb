require 'test_helper'

class BootstrapFormTest < ActionView::TestCase
  include BootstrapForm::Helper

  def setup
    setup_test_fixture
  end

  test "default-style forms" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| nil }
  end

  test "inline-style forms" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="form-inline" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :inline) { |f| nil }
  end

  test "horizontal-style forms" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="form-horizontal" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label col-sm-2 required" for="user_email">Email</label><div class="col-sm-10"><input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" /></div></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email }
  end

  test "existing styles aren't clobbered when specifying a form style" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="my-style form-horizontal" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label col-sm-2 required" for="user_email">Email</label><div class="col-sm-10"><input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" /></div></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal, html: { class: "my-style" }) { |f| f.email_field :email }
  end

  test "given role attribute should not be covered by default role attribute" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="not-a-form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user, html: { role: 'not-a-form'}) {|f| nil}
  end

  test "bootstrap_form_tag acts like a form tag" do
    expected = %{<form accept-charset="UTF-8" action="/users" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label" for="email">Your Email</label><input class="form-control" id="email" name="email" type="text" /></div></form>}
    assert_equivalent_xml expected, bootstrap_form_tag(url: '/users') { |f| f.text_field :email, label: "Your Email" }
  end

  test "bootstrap_form_tag does not clobber custom options" do
    expected = %{<form accept-charset="UTF-8" action="/users" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label" for="ID">Email</label><input class="form-control" id="ID" name="NAME" type="text" /></div></form>}
    assert_equivalent_xml expected, bootstrap_form_tag(url: '/users') { |f| f.text_field :email, name: 'NAME', id: "ID" }
  end

  test "bootstrap_form_tag allows an empty name for checkboxes" do
    expected = %{<form accept-charset="UTF-8" action="/users" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="checkbox"><label for="_misc"><input name="[misc]" type="hidden" value="0" /><input id="_misc" name="[misc]" type="checkbox" value="1" /> Misc</label></div></form>}
    assert_equivalent_xml expected, bootstrap_form_tag(url: '/users') { |f| f.check_box :misc }
  end

  test "errors display correctly and inline_errors are turned off by default when label_errors is true" do
    @user.email = nil
    @user.valid?

    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\"new_user\" id=\"new_user\" method=\"post\" role=\"form\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><div class=\"form-group has-error\"><label class=\"control-label required\" for=\"user_email\">Email can&#39;t be blank, is too short (minimum is 5 characters)</label><input class=\"form-control\" id=\"user_email\" name=\"user[email]\" type=\"text\" /></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user, label_errors: true) { |f| f.text_field :email }
  end

  test "errors display correctly and inline_errors can also be on when label_errors is true" do
    @user.email = nil
    @user.valid?

    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\"new_user\" id=\"new_user\" method=\"post\" role=\"form\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><div class=\"form-group has-error\"><label class=\"control-label required\" for=\"user_email\">Email can&#39;t be blank, is too short (minimum is 5 characters)</label><input class=\"form-control\" id=\"user_email\" name=\"user[email]\" type=\"text\" /><span class=\"help-block\">can&#39;t be blank, is too short (minimum is 5 characters)</span></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user, label_errors: true, inline_errors: true) { |f| f.text_field :email }
  end

  test "label error messages use humanized attribute names" do
    I18n.backend.store_translations(:en, {activerecord: {attributes: {user: {email: 'Your e-mail address'}}}})

    @user.email = nil
    @user.valid?

    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\"new_user\" id=\"new_user\" method=\"post\" role=\"form\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><div class=\"form-group has-error\"><label class=\"control-label required\" for=\"user_email\">Your e-mail address can&#39;t be blank, is too short (minimum is 5 characters)</label><input class=\"form-control\" id=\"user_email\" name=\"user[email]\" type=\"text\" /><span class=\"help-block\">can&#39;t be blank, is too short (minimum is 5 characters)</span></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user, label_errors: true, inline_errors: true) { |f| f.text_field :email }

    I18n.backend.store_translations(:en, {activerecord: {attributes: {user: {email: nil}}}})
  end

  test "alert message is wrapped correctly" do
    @user.email = nil
    @user.valid?
    expected = %{<div class="alert alert-danger"><p>Please fix the following errors:</p><ul class="rails-bootstrap-forms-error-summary"><li>Email can&#39;t be blank</li><li>Email is too short (minimum is 5 characters)</li><li>Terms must be accepted</li></ul></div>}
    assert_equivalent_xml expected, @builder.alert_message('Please fix the following errors:')
  end

  test "changing the class name for the alert message" do
    @user.email = nil
    @user.valid?
    expected = %{<div class="my-css-class"><p>Please fix the following errors:</p><ul class="rails-bootstrap-forms-error-summary"><li>Email can&#39;t be blank</li><li>Email is too short (minimum is 5 characters)</li><li>Terms must be accepted</li></ul></div>}
    assert_equivalent_xml expected, @builder.alert_message('Please fix the following errors:', class: 'my-css-class')
  end

  test "alert_message contains the error summary when inline_errors are turned off" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.alert_message('Please fix the following errors:')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="alert alert-danger"><p>Please fix the following errors:</p><ul class="rails-bootstrap-forms-error-summary"><li>Email can&#39;t be blank</li><li>Email is too short (minimum is 5 characters)</li><li>Terms must be accepted</li></ul></div></form>}
    assert_equivalent_xml expected, output
  end

  test "alert_message allows the error_summary to be turned off" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.alert_message('Please fix the following errors:', error_summary: false)
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="alert alert-danger"><p>Please fix the following errors:</p></div></form>}
    assert_equivalent_xml expected, output
  end

  test "alert_message allows the error_summary to be turned on with inline_errors also turned on" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user, inline_errors: true) do |f|
      f.alert_message('Please fix the following errors:', error_summary: true)
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="alert alert-danger"><p>Please fix the following errors:</p><ul class="rails-bootstrap-forms-error-summary"><li>Email can&#39;t be blank</li><li>Email is too short (minimum is 5 characters)</li><li>Terms must be accepted</li></ul></div></form>}
    assert_equivalent_xml expected, output
  end

  test "error_summary returns an unordered list of errors" do
    @user.email = nil
    @user.valid?

    expected = %{<ul class="rails-bootstrap-forms-error-summary"><li>Email can&#39;t be blank</li><li>Email is too short (minimum is 5 characters)</li><li>Terms must be accepted</li></ul>}
    assert_equivalent_xml expected, @builder.error_summary
  end

  test 'errors_on renders the errors for a specific attribute when invalid' do
    @user.email = nil
    @user.valid?

    expected = %{<div class="alert alert-danger">Email can&#39;t be blank, Email is too short (minimum is 5 characters)</div>}
    assert_equivalent_xml expected, @builder.errors_on(:email)
  end

  test "custom label width for horizontal forms" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="form-horizontal" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label col-sm-1 required" for="user_email">Email</label><div class="col-sm-10"><input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" /></div></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, label_col: 'col-sm-1' }
  end

  test "offset for form group without label respects label width for horizontal forms" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="form-horizontal" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><div class="col-md-10 col-md-offset-2"><input class="btn btn-default" name="commit" type="submit" value="Create User" /></div></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal, label_col: 'col-md-2', control_col: 'col-md-10') { |f| f.form_group { f.submit } }
  end

  test "custom input width for horizontal forms" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="form-horizontal" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label col-sm-2 required" for="user_email">Email</label><div class="col-sm-5"><input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" /></div></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, control_col: 'col-sm-5' }
  end

  test "the field contains the error and is not wrapped in div.field_with_errors when bootstrap_form_for is used" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group has-error"><label class="control-label required" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" /><span class="help-block">can&#39;t be blank, is too short (minimum is 5 characters)</span></div></form>}
    assert_equivalent_xml expected, output
  end

  test "the field is wrapped with div.field_with_errors when form_for is used" do
    @user.email = nil
    @user.valid?

    output = form_for(@user, builder: BootstrapForm::FormBuilder) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group has-error"><div class="field_with_errors"><label class="control-label required" for="user_email">Email</label></div><div class="field_with_errors"><input class="form-control" id="user_email" name="user[email]" type="text" /></div><span class="help-block">can&#39;t be blank, is too short (minimum is 5 characters)</span></div></form>}
    assert_equivalent_xml expected, output
  end

  test "help is preserved when inline_errors: false is passed to bootstrap_form_for" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group has-error"><label class="control-label required" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" /><span class="help-block">This is required</span></div></form>}
    assert_equivalent_xml expected, output
  end

  test "allows the form object to be nil" do
    builder = BootstrapForm::FormBuilder.new :other_model, nil, self, {}
    expected = %{<div class="form-group"><label class="control-label" for="other_model_email">Email</label><input class="form-control" id="other_model_email" name="other_model[email]" type="text" /></div>}
    assert_equivalent_xml expected, builder.text_field(:email)
  end

  test 'errors_on hide attribute name in message' do
    @user.email = nil
    @user.valid?

    expected = %{<div class="alert alert-danger">can&#39;t be blank, is too short (minimum is 5 characters)</div>}

    assert_equivalent_xml expected, @builder.errors_on(:email, hide_attribute_name: true)
  end
end
