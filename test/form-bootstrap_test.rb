require 'test_helper'

class FormBootstrapTest < ActionView::TestCase
  def setup
    @user = User.new(email: 'steve@example.com', password: 'secret', comments: 'my comment')
    @builder = FormBootstrap::Builder.new :user, @user, self, {}, nil
  end

  test "helper method to wrap form bootstrap builder" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div></form>}
    assert_equal expected, form_bootstrap_for(@user) { |f| nil }
  end

  test "alert message is wrapped correctly" do
    @user.email = nil
    @user.valid?
    expected = %{<div class="alert-message error">Please fix the following errors:</div>}
    assert_equal expected, @builder.alert_message('Please fix the following errors:')
  end

  test "changing the class name for the alert message" do
    @user.email = nil
    @user.valid?
    expected = %{<div class="my-css-class">Please fix the following errors:</div>}
    assert_equal expected, @builder.alert_message('Please fix the following errors:', class: 'my-css-class')
  end

  test "text fields are wrapped correctly" do
    expected = %{<div class="clearfix"><label for="user_email">Email</label><div class="input"><input id="user_email" name="user[email]" size="30" type="text" value="steve@example.com" /></div></div>}
    assert_equal expected, @builder.text_field(:email)
  end

  test "password fields are wrapped correctly" do
    expected = %{<div class="clearfix"><label for="user_password">Password</label><div class="input"><input id="user_password" name="user[password]" size="30" type="text" value="secret" /></div></div>}
    assert_equal expected, @builder.text_field(:password)
  end

  test "text areas are wrapped correctly" do
    expected = %{<div class="clearfix"><label for="user_comments">Comments</label><div class="input"><textarea cols="40" id="user_comments" name="user[comments]" rows="20">my comment</textarea></div></div>}
    assert_equal expected, @builder.text_area(:comments)
  end

  test "selects are wrapped correctly" do
    expected = %{<div class="clearfix"><label for="user_status">Status</label><div class="input"><select id="user_status" name="user[status]"></select></div></div>}
    assert_equal expected, @builder.collection_select(:status, [], :id, :name)
  end

  test "changing the label text" do
    expected = %{<div class="clearfix"><label for="user_email">Email Address</label><div class="input"><input id="user_email" name="user[email]" size="30" type="text" value="steve@example.com" /></div></div>}
    assert_equal expected, @builder.text_field(:email, label: 'Email Address')
  end

  test "actions are wrapped correctly" do
    expected = %{<div class="actions"><input class="btn primary" name="commit" type="submit" value="Submit" /></div>}
    assert_equal expected, @builder.actions('Submit')
  end

  test "passing :help to a field displays it inline" do
    expected = %{<div class="clearfix"><label for="user_email">Email</label><div class="input"><input id="user_email" name="user[email]" size="30" type="text" value="steve@example.com" /><span class="help-inline">This is required</span></div></div>}
    assert_equal expected, @builder.text_field(:email, help: 'This is required')
  end

  test "passing :help :block to the form builder" do
    output = form_bootstrap_for(@user, help: :block) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="clearfix"><label for="user_email">Email</label><div class="input"><input id="user_email" name="user[email]" size="30" type="text" value="steve@example.com" /><span class="help-block">This is required</span></div></div></form>}
    assert_equal expected, output
  end

  test "the field's inline help contains the error when invalid and inlined" do
    @user.email = nil
    @user.valid?
    expected = %{<div class="clearfix error"><label for="user_email">Email</label><div class="input"><input id="user_email" name="user[email]" size="30" type="text" /><span class="help-inline">can't be blank, is too short (minimum is 5 characters)</span></div></div>}
    assert_equal expected, @builder.text_field(:email, help: 'This should not be displayed')
  end
end

