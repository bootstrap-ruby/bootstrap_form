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

  test "file fields are wrapped correctly" do
    expected = %{<div class="clearfix"><label for="user_misc">Misc</label><div class="input"><input id="user_misc" name="user[misc]" type="file" /></div></div>}
    assert_equal expected, @builder.file_field(:misc)
  end

  test "date selects are wrapped correctly" do
    expected = %{<div class="clearfix"><label for="user_misc">Misc</label><div class="input"><select id="user_misc_1i" name="user[misc(1i)]">\n<option value="2007">2007</option>\n<option value="2008">2008</option>\n<option value="2009">2009</option>\n<option value="2010">2010</option>\n<option value="2011">2011</option>\n<option selected="selected" value="2012">2012</option>\n<option value="2013">2013</option>\n<option value="2014">2014</option>\n<option value="2015">2015</option>\n<option value="2016">2016</option>\n<option value="2017">2017</option>\n</select>\n<select id="user_misc_2i" name="user[misc(2i)]">\n<option selected="selected" value="1">January</option>\n<option value="2">February</option>\n<option value="3">March</option>\n<option value="4">April</option>\n<option value="5">May</option>\n<option value="6">June</option>\n<option value="7">July</option>\n<option value="8">August</option>\n<option value="9">September</option>\n<option value="10">October</option>\n<option value="11">November</option>\n<option value="12">December</option>\n</select>\n<select id="user_misc_3i" name="user[misc(3i)]">\n<option value="1">1</option>\n<option value="2">2</option>\n<option value="3">3</option>\n<option value="4">4</option>\n<option value="5">5</option>\n<option value="6">6</option>\n<option value="7">7</option>\n<option value="8">8</option>\n<option value="9">9</option>\n<option value="10">10</option>\n<option selected="selected" value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n</select>\n</div></div>}
    assert_equal expected, @builder.date_select(:misc)
  end

  test "check_boxes are wrapped correctly" do
    expected = %{<div class="clearfix"><div class="input"><label for="user_misc"><input name="user[misc]" type="hidden" value="0" /><input id="user_misc" name="user[misc]" type="checkbox" value="1" /> <span>This is a checkbox</span></label></div></div>}
    assert_equal expected, @builder.check_box(:misc, label: 'This is a checkbox')
  end

  test "changing the label text" do
    expected = %{<div class="clearfix"><label for="user_email">Email Address</label><div class="input"><input id="user_email" name="user[email]" size="30" type="text" value="steve@example.com" /></div></div>}
    assert_equal expected, @builder.text_field(:email, label: 'Email Address')
  end

  test "passing :help to a field displays it inline" do
    expected = %{<div class="clearfix"><label for="user_email">Email</label><div class="input"><input id="user_email" name="user[email]" size="30" type="text" value="steve@example.com" /><span class="help-inline">This is required</span></div></div>}
    assert_equal expected, @builder.text_field(:email, help: 'This is required')
  end

  test "passing other options to a field get passed through" do
    expected = %{<div class="clearfix"><label for="user_email">Email</label><div class="input"><input autofocus="autofocus" id="user_email" name="user[email]" size="30" type="text" value="steve@example.com" /></div></div>}
    assert_equal expected, @builder.text_field(:email, autofocus: true)
  end

  test "actions are wrapped correctly" do
    output = @builder.actions do
      'something'
    end
    expected = %{<div class="actions">something</div>}
    assert_equal expected, output
  end

  test "primary buttons the correct classes" do
    expected = %{<input class="btn primary" name="commit" type="submit" value="Submit" />}
    assert_equal expected, @builder.primary('Submit')
  end

  test "passing :help :block to the form builder" do
    output = form_bootstrap_for(@user, help: :block) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="clearfix"><label for="user_email">Email</label><div class="input"><input id="user_email" name="user[email]" size="30" type="text" value="steve@example.com" /><span class="help-block">This is required</span></div></div></form>}
    assert_equal expected, output
  end

  test "the field contains the error and is not wrapped in div.field_with_errors when form_bootstrap_for is used" do
    @user.email = nil
    @user.valid?

    output = form_bootstrap_for(@user, help: :block) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="clearfix error"><label for="user_email">Email</label><div class="input"><input id="user_email" name="user[email]" size="30" type="text" /><span class="help-block">can't be blank, is too short (minimum is 5 characters)</span></div></div></form>}
    assert_equal expected, output
  end

  test "the field is wrapped with div.field_with_errors when form_for is used" do
    @user.email = nil
    @user.valid?

    output = form_for(@user, builder: FormBootstrap::Builder, help: :block) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="clearfix error"><div class="field_with_errors"><label for="user_email">Email</label></div><div class="input"><div class="field_with_errors"><input id="user_email" name="user[email]" size="30" type="text" /></div><span class="help-block">can't be blank, is too short (minimum is 5 characters)</span></div></div></form>}
    assert_equal expected, output
  end
end

