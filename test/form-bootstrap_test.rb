require 'test_helper'

class FormBootstrapTest < ActionView::TestCase
  def setup
    @user = User.new(email: 'steve@example.com', password: 'secret', comments: 'my comment')
    @builder = FormBootstrap::Builder.new :user, @user, self, {}, nil
  end

  test "text fields are wrapped correctly" do
    expected = %{<div class="clearfix"><label for="user_email">Email</label><div class="input"><input id="user_email" name="user[email]" size="30" type="text" value="steve@example.com" /><span class="help-inline"></span></div></div>}
    assert_equal expected, @builder.text_field(:email)
  end

  test "password fields are wrapped correctly" do
    expected = %{<div class="clearfix"><label for="user_password">Password</label><div class="input"><input id="user_password" name="user[password]" size="30" type="text" value="secret" /><span class="help-inline"></span></div></div>}
    assert_equal expected, @builder.text_field(:password)
  end

  test "text areas are wrapped correctly" do
    expected = %{<div class="clearfix"><label for="user_comments">Comments</label><div class="input"><textarea cols="40" id="user_comments" name="user[comments]" rows="20">my comment</textarea><span class="help-inline"></span></div></div>}
    assert_equal expected, @builder.text_area(:comments)
  end

  test "selects are wrapped correctly" do
    expected = %{<div class="clearfix"><label for="user_status">Status</label><div class="input"><select id="user_status" name="user[status]"></select><span class="help-inline"></span></div></div>}
    assert_equal expected, @builder.collection_select(:status, [], :id, :name)
  end

  test "actions are wrapped correctly" do
    expected = %{<div class="actions"><input class="btn primary" name="commit" type="submit" value="Submit" /></div>}
    assert_equal expected, @builder.actions('Submit')
  end

  test "error messages are wrapped correctly" do
    @user.email = nil
    @user.valid?
    expected = %{<div class="alert-message error"><p>Please fix the following errors:</p></div>}
    assert_equal expected, @builder.error_message('Please fix the following errors:')
  end

  test "help message contains the field error when invalid" do
    @user.email = nil
    @user.valid?
    expected = %{<div class="clearfix error"><div class="field_with_errors"><label for="user_email">Email</label></div><div class="input"><div class="field_with_errors"><input id="user_email" name="user[email]" size="30" type="text" /></div><span class="help-inline">can't be blank, is too short (minimum is 5 characters)</span></div></div>}
    assert_equal expected, @builder.text_field(:email)
  end

  test "helper method to wrap form bootstrap builder" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div></form>}
    assert_equal expected, form_bootstrap_for(@user) { |f| nil }
  end
end

