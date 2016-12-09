require 'test_helper'

class BootstrapFormGroupTest < ActionView::TestCase
  include BootstrapForm::Helper

  def setup
    setup_test_fixture
  end

  test "changing the label text via the label option parameter" do
    expected = %{<div class="form-group"><label class="control-label required" for="user_email">Email Address</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, label: 'Email Address')
  end

  test "changing the label text via the html_options label hash" do
    expected = %{<div class="form-group"><label class="control-label required" for="user_email">Email Address</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, label: {text: 'Email Address'})
  end

  test "hiding a label" do
    expected = %{<div class="form-group"><label class="sr-only control-label required" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, hide_label: true)
  end

  test "adding a custom label class via the label_class parameter" do
    expected = %{<div class="form-group"><label class="btn control-label required" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, label_class: 'btn')
  end

  test "adding a custom label class via the html_options label hash" do
    expected = %{<div class="form-group"><label class="btn control-label required" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, label: {class: 'btn'})
  end

  test "adding a custom label and changing the label text via the html_options label hash" do
    expected = %{<div class="form-group"><label class="btn control-label required" for="user_email">Email Address</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, label: {class: 'btn', text: "Email Address"})
  end

  test "skipping a label" do
    expected = %{<div class="form-group"><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, skip_label: true)
  end

  test "preventing a label from having the required class" do
    expected = %{<div class="form-group"><label class="control-label" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, skip_required: true)
  end

  test "adding prepend text" do
    expected = %{<div class="form-group"><label class="control-label required" for="user_email">Email</label><div class="input-group"><span class="input-group-addon">@</span><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, prepend: '@')
  end

  test "adding append text" do
    expected = %{<div class="form-group"><label class="control-label required" for="user_email">Email</label><div class="input-group"><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /><span class="input-group-addon">.00</span></div></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, append: '.00')
  end

  test "append and prepend button" do
    prefix = %{<div class="form-group"><label class="control-label required" for="user_email">Email</label><div class="input-group">}
    field = %{<input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />}
    button = %{<span class="input-group-btn"><a class="btn btn-default" href="#">Click</a></span>}
    suffix = %{</div></div>}
    after_button = prefix + field + button + suffix
    before_button = prefix + button + field + suffix
    both_button = prefix + button + field + button  + suffix
    button_src = link_to("Click", "#", class: "btn btn-default")
    assert_equivalent_xml after_button, @builder.text_field(:email, append: button_src)
    assert_equivalent_xml before_button, @builder.text_field(:email, prepend: button_src)
    assert_equivalent_xml both_button, @builder.text_field(:email, append: button_src, prepend: button_src)
  end

  test "adding both prepend and append text" do
    expected = %{<div class="form-group"><label class="control-label required" for="user_email">Email</label><div class="input-group"><span class="input-group-addon">$</span><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /><span class="input-group-addon">.00</span></div></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, prepend: '$', append: '.00')
  end

  test "help messages for default forms" do
    expected = %{<div class="form-group"><label class="control-label required" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /><span class="help-block">This is required</span></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, help: 'This is required')
  end

  test "help messages for horizontal forms" do
    expected = %{<div class="form-group"><label class="control-label col-sm-2 required" for="user_email">Email</label><div class="col-sm-10"><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /><span class="help-block">This is required</span></div></div>}
    assert_equivalent_xml expected, @horizontal_builder.text_field(:email, help: "This is required")
  end

  test "help messages to look up I18n automatically" do
    expected = %{<div class="form-group"><label class="control-label" for="user_password">Password</label><input class="form-control" id="user_password" name="user[password]" type="text" value="secret" /><span class="help-block">A good password should be at least six characters long</span></div>}
    assert_equivalent_xml expected, @builder.text_field(:password)
  end

  test "help messages to warn about deprecated I18n key" do
    super_user = SuperUser.new(@user.attributes)
    builder = BootstrapForm::FormBuilder.new(:super_user, super_user, self, {})

    I18n.backend.store_translations(:en, activerecord: {
      help: {
        superuser: {
          password: 'A good password should be at least six characters long'
        }
      }
    })

    builder.stubs(:warn).returns(true)
    builder.expects(:warn).at_least_once

    builder.password_field(:password)
  end

  test "help messages to ignore translation when user disables help" do
    expected = %{<div class="form-group"><label class="control-label" for="user_password">Password</label><input class="form-control" id="user_password" name="user[password]" type="text" value="secret" /></div>}
    assert_equivalent_xml expected, @builder.text_field(:password, help: false)
  end

  test "form_group creates a valid structure and allows arbitrary html to be added via a block" do
    output = @horizontal_builder.form_group :nil, label: { text: 'Foo' } do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group"><label class="control-label col-sm-2" for="user_nil">Foo</label><div class="col-sm-10"><p class="form-control-static">Bar</p></div></div>}
    assert_equivalent_xml expected, output
  end

  test "form_group adds a spacer when no label exists for a horizontal form" do
    output = @horizontal_builder.form_group do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group"><div class="col-sm-10 col-sm-offset-2"><p class="form-control-static">Bar</p></div></div>}
    assert_equivalent_xml expected, output
  end

  test "form_group renders the label correctly" do
    output = @horizontal_builder.form_group :email, label: { text: 'Custom Control' } do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group"><label class="control-label col-sm-2 required" for="user_email">Custom Control</label><div class="col-sm-10"><p class="form-control-static">Bar</p></div></div>}
    assert_equivalent_xml expected, output
  end

  test "form_group accepts class thorugh options hash" do
    output = @horizontal_builder.form_group :email, class: "foo" do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group foo"><div class="col-sm-10 col-sm-offset-2"><p class="form-control-static">Bar</p></div></div>}
    assert_equivalent_xml expected, output
  end

  test "form_group accepts class thorugh options hash without needing a name" do
    output = @horizontal_builder.form_group class: "foo" do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group foo"><div class="col-sm-10 col-sm-offset-2"><p class="form-control-static">Bar</p></div></div>}
    assert_equivalent_xml expected, output
  end

  test "form_group overrides the label's 'class' and 'for' attributes if others are passed" do
    output = @horizontal_builder.form_group nil, label: { text: 'Custom Control', class: 'foo', for: 'bar' } do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group"><label class="foo control-label col-sm-2" for="bar">Custom Control</label><div class="col-sm-10"><p class="form-control-static">Bar</p></div></div>}
    assert_equivalent_xml expected, output
  end

  test 'form_group renders the "error" class and message corrrectly when object is invalid' do
    @user.email = nil
    @user.valid?

    output = @builder.form_group :email do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group has-error"><p class="form-control-static">Bar</p><span class="help-block">can&#39;t be blank, is too short (minimum is 5 characters)</span></div>}
    assert_equivalent_xml expected, output
  end

  test "adds class to wrapped form_group by a field" do
    expected = %{<div class="form-group none-margin"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="search" /></div>}
    assert_equivalent_xml expected, @builder.search_field(:misc, wrapper_class: 'none-margin')
  end

  test "adds class to wrapped form_group by a field with errors" do
    @user.email = nil
    @user.valid?

    expected = %{<div class="form-group none-margin has-error"><div class="field_with_errors"><label class="control-label required" for="user_email">Email</label></div><div class="field_with_errors"><input class="form-control" id="user_email" name="user[email]" type="email" /></div><span class="help-block">can&#39;t be blank, is too short (minimum is 5 characters)</span></div>}
    assert_equivalent_xml expected, @builder.email_field(:email, wrapper_class: 'none-margin')
  end

  test "adds class to wrapped form_group by a field with errors when bootstrap_form_for is used" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user) do |f|
      f.text_field(:email, help: 'This is required', wrapper_class: 'none-margin')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group none-margin has-error"><label class="control-label required" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" /><span class="help-block">can&#39;t be blank, is too short (minimum is 5 characters)</span></div></form>}
    assert_equivalent_xml expected, output
  end

  test "adds offset for form_group without label" do
    output = @horizontal_builder.form_group do
      @horizontal_builder.submit
    end

    expected = %{<div class="form-group"><div class="col-sm-10 col-sm-offset-2"><input class="btn btn-default" name="commit" type="submit" value="Create User" /></div></div>}
    assert_equivalent_xml expected, output
  end

  test "adds offset for form_group without label but specific label_col" do
    output = @horizontal_builder.form_group label_col: 'col-sm-5', control_col: 'col-sm-8' do
      @horizontal_builder.submit
    end

    expected = %{<div class="form-group"><div class="col-sm-8 col-sm-offset-5"><input class="btn btn-default" name="commit" type="submit" value="Create User" /></div></div>}
    assert_equivalent_xml expected, output
  end

  test "adding an icon to a field" do
    expected = %{<div class="form-group has-feedback"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="email" /><span class="glyphicon glyphicon-ok form-control-feedback"></span></div>}
    assert_equivalent_xml expected, @builder.email_field(:misc, icon: 'ok')
  end

  test "single form_group call in horizontal form should not be smash design" do
    output = ''
    output = @horizontal_builder.form_group do
      "Hallo"
    end

    output = output + @horizontal_builder.text_field(:email)

    expected = %{<div class="form-group"><div class="col-sm-10 col-sm-offset-2">Hallo</div></div><div class="form-group"><label class="control-label col-sm-2 required" for="user_email">Email</label><div class="col-sm-10"><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div></div>}
    assert_equivalent_xml expected, output
  end

  test "adds data-attributes (or any other options) to wrapper" do
    expected = %{<div class="form-group" data-foo="bar"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="search" /></div>}
    assert_equivalent_xml expected, @builder.search_field(:misc, wrapper: { data: { foo: 'bar' } })
  end

  test "passing options to a form control get passed through" do
    expected = %{<div class="form-group"><label class="control-label required" for="user_email">Email</label><input autofocus="autofocus" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equivalent_xml expected, @builder.text_field(:email, autofocus: true)
  end

  test "doesn't throw undefined method error when the content block returns nil" do
    output = @builder.form_group :nil, label: { text: 'Foo' } do
      nil
    end

    expected = %{<div class="form-group"><label class="control-label" for="user_nil">Foo</label></div>}
    assert_equivalent_xml expected, output
  end

  test "custom form group layout option" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="form-horizontal" id="new_user" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label required" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" /></div></form>}
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, layout: :inline }
  end

  test "non-default column span on form is reflected in form_group" do
    non_default_horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, { layout: :horizontal, label_col: "col-sm-3", control_col: "col-sm-9" })
    output = non_default_horizontal_builder.form_group do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group"><div class="col-sm-9 col-sm-offset-3"><p class="form-control-static">Bar</p></div></div>}
    assert_equivalent_xml expected, output
  end

  test "non-default column span on form isn't mutated" do
    frozen_horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, { layout: :horizontal, label_col: "col-sm-3".freeze, control_col: "col-sm-9".freeze })
    output = frozen_horizontal_builder.form_group { 'test' }

    expected = %{<div class="form-group"><div class="col-sm-9 col-sm-offset-3">test</div></div>}
    assert_equivalent_xml expected, output
  end

  test ":input_group_class should apply to input-group" do
    expected = %{<div class="form-group"><label class="control-label required" for="user_email">Email</label><div class="input-group input-group-lg"><input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" /><span class="input-group-btn"><input class="btn btn-primary" name="commit" type="submit" value="Subscribe" /></span></div></div>}
    assert_equivalent_xml expected, @builder.email_field(:email, append: @builder.primary('Subscribe'), input_group_class: 'input-group-lg')
  end
end
