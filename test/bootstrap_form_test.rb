require 'test_helper'

class BootstrapFormTest < ActionView::TestCase
  def setup
    @user = User.new(email: 'steve@example.com', password: 'secret', comments: 'my comment')
    @builder = BootstrapForm::FormBuilder.new :user, @user, self, {}, nil
  end

  test "helper method to wrap bootstrap a vertical form builder" do
    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\" form-vertical\" id=\"new_user\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div></form>}
    assert_equal expected, bootstrap_form_for(@user) { |f| nil }
  end

  test "helper method to wrap bootstrap a horizontal form builder" do
    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\"form-horizontal\" id=\"new_user\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div></form>}
    assert_equal expected, bootstrap_form_for(@user, html: { class: 'form-horizontal' }) { |f| nil }
  end

  test "alert message is wrapped correctly" do
    @user.email = nil
    @user.valid?
    expected = %{<div class="alert alert-error">Please fix the following errors:</div>}
    assert_equal expected, @builder.alert_message('Please fix the following errors:')
  end

  test "changing the class name for the alert message" do
    @user.email = nil
    @user.valid?
    expected = %{<div class="my-css-class">Please fix the following errors:</div>}
    assert_equal expected, @builder.alert_message('Please fix the following errors:', class: 'my-css-class')
  end

  test "text fields are wrapped correctly" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><input id=\"user_email\" name=\"user[email]\" size=\"30\" type=\"text\" value=\"steve@example.com\" /></div></div>}
    assert_equal expected, @builder.text_field(:email)
  end

  test "password fields are wrapped correctly" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_password\">Password</label><div class=\"controls\"><input id=\"user_password\" name=\"user[password]\" size=\"30\" type=\"text\" value=\"secret\" /></div></div>}
    assert_equal expected, @builder.text_field(:password)
  end

  test "text areas are wrapped correctly" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_comments\">Comments</label><div class=\"controls\"><textarea cols=\"40\" id=\"user_comments\" name=\"user[comments]\" rows=\"20\">my comment</textarea></div></div>}
    assert_equal expected, @builder.text_area(:comments)
  end

  test "selects are wrapped correctly (select)" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_status\">Status</label><div class=\"controls\"><select id=\"user_status\" name=\"user[status]\"><option value=\"1\">activated</option>\n<option value=\"2\">blocked</option></select></div></div>}
    assert_equal expected, @builder.select(:status, [['activated', 1], ['blocked', 2]])
  end

  test "selects are wrapped correctly (collection_select)" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_status\">Status</label><div class=\"controls\"><select id=\"user_status\" name=\"user[status]\"></select></div></div>}
    assert_equal expected, @builder.collection_select(:status, [], :id, :name)
  end

  test "file fields are wrapped correctly" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_misc\">Misc</label><div class=\"controls\"><input id=\"user_misc\" name=\"user[misc]\" type=\"file\" /></div></div>}
    assert_equal expected, @builder.file_field(:misc)
  end

  test "date selects are wrapped correctly" do
    Timecop.freeze(new_time = Time.local(2012, 2, 3, 12, 0, 0)) do
      expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_misc\">Misc</label><div class=\"controls\"><select id=\"user_misc_1i\" name=\"user[misc(1i)]\">\n<option value=\"2007\">2007</option>\n<option value=\"2008\">2008</option>\n<option value=\"2009\">2009</option>\n<option value=\"2010\">2010</option>\n<option value=\"2011\">2011</option>\n<option selected=\"selected\" value=\"2012\">2012</option>\n<option value=\"2013\">2013</option>\n<option value=\"2014\">2014</option>\n<option value=\"2015\">2015</option>\n<option value=\"2016\">2016</option>\n<option value=\"2017\">2017</option>\n</select>\n<select id=\"user_misc_2i\" name=\"user[misc(2i)]\">\n<option value=\"1\">January</option>\n<option selected=\"selected\" value=\"2\">February</option>\n<option value=\"3\">March</option>\n<option value=\"4\">April</option>\n<option value=\"5\">May</option>\n<option value=\"6\">June</option>\n<option value=\"7\">July</option>\n<option value=\"8\">August</option>\n<option value=\"9\">September</option>\n<option value=\"10\">October</option>\n<option value=\"11\">November</option>\n<option value=\"12\">December</option>\n</select>\n<select id=\"user_misc_3i\" name=\"user[misc(3i)]\">\n<option value=\"1\">1</option>\n<option value=\"2\">2</option>\n<option selected=\"selected\" value=\"3\">3</option>\n<option value=\"4\">4</option>\n<option value=\"5\">5</option>\n<option value=\"6\">6</option>\n<option value=\"7\">7</option>\n<option value=\"8\">8</option>\n<option value=\"9\">9</option>\n<option value=\"10\">10</option>\n<option value=\"11\">11</option>\n<option value=\"12\">12</option>\n<option value=\"13\">13</option>\n<option value=\"14\">14</option>\n<option value=\"15\">15</option>\n<option value=\"16\">16</option>\n<option value=\"17\">17</option>\n<option value=\"18\">18</option>\n<option value=\"19\">19</option>\n<option value=\"20\">20</option>\n<option value=\"21\">21</option>\n<option value=\"22\">22</option>\n<option value=\"23\">23</option>\n<option value=\"24\">24</option>\n<option value=\"25\">25</option>\n<option value=\"26\">26</option>\n<option value=\"27\">27</option>\n<option value=\"28\">28</option>\n<option value=\"29\">29</option>\n<option value=\"30\">30</option>\n<option value=\"31\">31</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.date_select(:misc)
    end
  end

  test "check_boxes are wrapped correctly" do
    expected = %{<div class=\"control-group\"><div class=\"controls\"><label class=\"checkbox\" for=\"user_misc\"><input name=\"user[misc]\" type=\"hidden\" value=\"0\" /><input id=\"user_misc\" name=\"user[misc]\" type=\"checkbox\" value=\"1\" /> This is a checkbox</label></div></div>}
    assert_equal expected, @builder.check_box(:misc, label: 'This is a checkbox')
  end

  test "changing the label text" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email Address</label><div class=\"controls\"><input id=\"user_email\" name=\"user[email]\" size=\"30\" type=\"text\" value=\"steve@example.com\" /></div></div>}
    assert_equal expected, @builder.text_field(:email, label: 'Email Address')
  end

  test "passing :help to a field displays it inline" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><input id=\"user_email\" name=\"user[email]\" size=\"30\" type=\"text\" value=\"steve@example.com\" /><span class=\"help-inline\">This is required</span></div></div>}
    assert_equal expected, @builder.text_field(:email, help: 'This is required')
  end

  test "passing other options to a field get passed through" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><input autofocus=\"autofocus\" id=\"user_email\" name=\"user[email]\" size=\"30\" type=\"text\" value=\"steve@example.com\" /></div></div>}
    assert_equal expected, @builder.text_field(:email, autofocus: true)
  end

  test "actions are wrapped correctly" do
    output = @builder.actions do
      'something'
    end
    expected = %{<div class="form-actions">something</div>}
    assert_equal expected, output
  end

  test "primary button contains the correct classes" do
    expected = %{<input class=\"btn btn-primary\" name=\"commit\" type=\"submit\" value=\"Submit\" />}
    assert_equal expected, @builder.primary('Submit')
  end

  test "primary button with a disabled state" do
    expected = %{<input class=\"btn btn-primary\" data-disable-with="Saving..." name=\"commit\" type=\"submit\" value=\"Submit\" />}
    assert_equal expected, @builder.primary('Submit', disable_with: 'Saving...')
  end

  test "passing :help :block to the form builder" do
    output = bootstrap_form_for(@user, help: :block) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\" form-vertical\" id=\"new_user\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><input id=\"user_email\" name=\"user[email]\" size=\"30\" type=\"text\" value=\"steve@example.com\" /><p class=\"help-block\">This is required</p></div></div></form>}
    assert_equal expected, output
  end

  test "the field contains the error and is not wrapped in div.field_with_errors when bootstrap_form_for is used" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user, help: :block) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\" form-vertical\" id=\"new_user\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><div class=\"control-group error\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><input id=\"user_email\" name=\"user[email]\" size=\"30\" type=\"text\" /><p class=\"help-block\">can't be blank, is too short (minimum is 5 characters)</p></div></div></form>}
    assert_equal expected, output
  end

  test "the field is wrapped with div.field_with_errors when form_for is used" do
    @user.email = nil
    @user.valid?

    output = form_for(@user, builder: BootstrapForm::FormBuilder, help: :block) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\"new_user\" id=\"new_user\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><div class=\"control-group error\"><div class=\"field_with_errors\"><label class=\"control-label\" for=\"user_email\">Email</label></div><div class=\"controls\"><div class=\"field_with_errors\"><input id=\"user_email\" name=\"user[email]\" size=\"30\" type=\"text\" /></div><p class=\"help-block\">can't be blank, is too short (minimum is 5 characters)</p></div></div></form>}
    assert_equal expected, output
  end
end

