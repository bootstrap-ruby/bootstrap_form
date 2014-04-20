require 'test_helper'

class BootstrapFormTest < ActionView::TestCase
  include BootstrapForm::Helper

  def setup
    @user = User.new(email: 'steve@example.com', password: 'secret', comments: 'my comment')
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    @horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, { layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10" })
  end

  test "default-style forms" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div></form>}
    assert_equal expected, bootstrap_form_for(@user) { |f| nil }
  end

  test "inline-style forms" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="form-inline" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div></form>}
    assert_equal expected, bootstrap_form_for(@user, layout: :inline) { |f| nil }
  end

  test "horizontal-style forms" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="form-horizontal" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label col-sm-2" for="user_email">Email</label><div class="col-sm-10"><input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" /></div></div></form>}
    assert_equal expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email }
  end

  test "existing styles aren't clobbered when specifying a form style" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="my-style form-horizontal" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label col-sm-2" for="user_email">Email</label><div class="col-sm-10"><input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" /></div></div></form>}
    assert_equal expected, bootstrap_form_for(@user, layout: :horizontal, html: { class: "my-style" }) { |f| f.email_field :email }
  end

  test "bootstrap_form_tag acts like a form tag" do
    expected = %{<form accept-charset="UTF-8" action="/users" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label" for="email">Your Email</label><input class="form-control" id="email" name="email" type="text" /></div></form>}
    assert_equal expected, bootstrap_form_tag(url: '/users') { |f| f.text_field :email, label: "Your Email" }
  end

  test "bootstrap_form_tag does not clobber custom options" do
    expected = %{<form accept-charset="UTF-8" action="/users" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label" for="ID">Email</label><input class="form-control" id="ID" name="NAME" type="text" /></div></form>}
    assert_equal expected, bootstrap_form_tag(url: '/users') { |f| f.text_field :email, name: 'NAME', id: "ID" }
  end

  test "alert message is wrapped correctly" do
    @user.email = nil
    @user.valid?
    expected = %{<div class="alert alert-danger"><p>Please fix the following errors:</p></div>}
    assert_equal expected, @builder.alert_message('Please fix the following errors:')
  end

  test "changing the class name for the alert message" do
    @user.email = nil
    @user.valid?
    expected = %{<div class="my-css-class"><p>Please fix the following errors:</p></div>}
    assert_equal expected, @builder.alert_message('Please fix the following errors:', class: 'my-css-class')
  end

  test "alert_message contains the error summary when inline_errors are turned off" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.alert_message('Please fix the following errors:')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="alert alert-danger"><p>Please fix the following errors:</p><ul class="rails-bootstrap-forms-error-summary"><li>Email can&#39;t be blank</li><li>Email is too short (minimum is 5 characters)</li><li>Terms must be accepted</li></ul></div></form>}
    assert_equal expected, output
  end

  test "alert_message allows the error_summary to be turned off" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.alert_message('Please fix the following errors:', error_summary: false)
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="alert alert-danger"><p>Please fix the following errors:</p></div></form>}
    assert_equal expected, output
  end

  test "error_summary returns an unordered list of errors" do
    @user.email = nil
    @user.valid?

    expected = %{<ul class="rails-bootstrap-forms-error-summary"><li>Email can&#39;t be blank</li><li>Email is too short (minimum is 5 characters)</li><li>Terms must be accepted</li></ul>}
    assert_equal expected, @builder.error_summary
  end

  test 'errors_on renders the errors for a specific attribute when invalid' do
    @user.email = nil
    @user.valid?

    expected = %{<div class="alert alert-danger">Email can&#39;t be blank, Email is too short (minimum is 5 characters)</div>}
    assert_equal expected, @builder.errors_on(:email)
  end

  test "color fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="color" value="#000000" /></div>}
    assert_equal expected, @builder.color_field(:misc)
  end

  test "date fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="date" /></div>}
    assert_equal expected, @builder.date_field(:misc)
  end

  test "date time fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="datetime" /></div>}
    assert_equal expected, @builder.datetime_field(:misc)
  end

  test "date time local fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="datetime-local" /></div>}
    assert_equal expected, @builder.datetime_local_field(:misc)
  end

  test "email fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="email" /></div>}
    assert_equal expected, @builder.email_field(:misc)
  end

  test "file fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input id="user_misc" name="user[misc]" type="file" /></div>}
    assert_equal expected, @builder.file_field(:misc)
  end

  test "hidden fields are supported" do
    expected = %{<input id="user_misc" name="user[misc]" type="hidden" />}
    assert_equal expected, @builder.hidden_field(:misc)
  end

  test "month local fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="month" /></div>}
    assert_equal expected, @builder.month_field(:misc)
  end

  test "number fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="number" /></div>}
    assert_equal expected, @builder.number_field(:misc)
  end

  test "password fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_password">Password</label><input class="form-control" id="user_password" name="user[password]" type="password" /></div>}
    assert_equal expected, @builder.password_field(:password)
  end

  test "phone/telephone fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="tel" /></div>}
    assert_equal expected, @builder.phone_field(:misc)
    assert_equal expected, @builder.telephone_field(:misc)
  end

  test "range fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="range" /></div>}
    assert_equal expected, @builder.range_field(:misc)
  end

  test "search fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="search" /></div>}
    assert_equal expected, @builder.search_field(:misc)
  end

  test "text areas are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_comments">Comments</label><textarea class="form-control" id="user_comments" name="user[comments]">\nmy comment</textarea></div>}
    assert_equal expected, @builder.text_area(:comments)
  end

  test "text fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equal expected, @builder.text_field(:email)
  end

  test "time fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="time" /></div>}
    assert_equal expected, @builder.time_field(:misc)
  end

  test "url fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="url" /></div>}
    assert_equal expected, @builder.url_field(:misc)
  end

  test "week fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" id="user_misc" name="user[misc]" type="week" /></div>}
    assert_equal expected, @builder.week_field(:misc)
  end

  test "selects are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_status">Status</label><select class="form-control" id="user_status" name="user[status]"><option value="1">activated</option>\n<option value="2">blocked</option></select></div>}
    assert_equal expected, @builder.select(:status, [['activated', 1], ['blocked', 2]])
  end

  test "bootstrap_specific options are handled correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_status">My Status Label</label><select class="form-control" id="user_status" name="user[status]"><option value="1">activated</option>\n<option value="2">blocked</option></select><span class="help-block">Help!</span></div>}
    assert_equal expected, @builder.select(:status, [['activated', 1], ['blocked', 2]], label: "My Status Label", help: "Help!" )
  end

  test "selects with options are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_status">Status</label><select class="form-control" id="user_status" name="user[status]"><option value="">Please Select</option>\n<option value="1">activated</option>\n<option value="2">blocked</option></select></div>}
    assert_equal expected, @builder.select(:status, [['activated', 1], ['blocked', 2]], prompt: "Please Select")
  end

  test "selects with both options and html_options are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_status">Status</label><select class="form-control my-select" id="user_status" name="user[status]"><option value="">Please Select</option>\n<option value="1">activated</option>\n<option value="2">blocked</option></select></div>}
    assert_equal expected, @builder.select(:status, [['activated', 1], ['blocked', 2]], { prompt: "Please Select" }, class: "my-select")
  end

  test "selects render labels properly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_status">User Status</label><select class="form-control" id="user_status" name="user[status]"><option value="1">activated</option>\n<option value="2">blocked</option></select></div>}
    assert_equal expected, @builder.select(:status, [['activated', 1], ['blocked', 2]], label: "User Status")
  end

  test "collection_selects are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_status">Status</label><select class="form-control" id="user_status" name="user[status]"></select></div>}
    assert_equal expected, @builder.collection_select(:status, [], :id, :name)
  end

  test "collection_selects with options are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_status">Status</label><select class="form-control" id="user_status" name="user[status]"><option value="">Please Select</option>\n</select></div>}
    assert_equal expected, @builder.collection_select(:status, [], :id, :name, prompt: "Please Select")
  end

  test "collection_selects with options and html_options are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_status">Status</label><select class="form-control my-select" id="user_status" name="user[status]"><option value="">Please Select</option>\n</select></div>}
    assert_equal expected, @builder.collection_select(:status, [], :id, :name, { prompt: "Please Select" }, class: "my-select")
  end

  test "grouped_collection_selects are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_status">Status</label><select class="form-control" id="user_status" name="user[status]"></select></div>}
    assert_equal expected, @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s)
  end

  test "grouped_collection_selects with options are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_status">Status</label><select class="form-control" id="user_status" name="user[status]"><option value="">Please Select</option>\n</select></div>}
    assert_equal expected, @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s, prompt: "Please Select")
  end

  test "grouped_collection_selects with options and html_options are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_status">Status</label><select class="form-control my-select" id="user_status" name="user[status]"><option value="">Please Select</option>\n</select></div>}
    assert_equal expected, @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s, { prompt: "Please Select" }, class: "my-select")
  end

  test "date selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3)) do
      expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="rails-bootstrap-forms-date-select"><select class="form-control" id="user_misc_1i" name="user[misc(1i)]">\n<option value="2007">2007</option>\n<option value="2008">2008</option>\n<option value="2009">2009</option>\n<option value="2010">2010</option>\n<option value="2011">2011</option>\n<option selected="selected" value="2012">2012</option>\n<option value="2013">2013</option>\n<option value="2014">2014</option>\n<option value="2015">2015</option>\n<option value="2016">2016</option>\n<option value="2017">2017</option>\n</select>\n<select class="form-control" id="user_misc_2i" name="user[misc(2i)]">\n<option value="1">January</option>\n<option selected="selected" value="2">February</option>\n<option value="3">March</option>\n<option value="4">April</option>\n<option value="5">May</option>\n<option value="6">June</option>\n<option value="7">July</option>\n<option value="8">August</option>\n<option value="9">September</option>\n<option value="10">October</option>\n<option value="11">November</option>\n<option value="12">December</option>\n</select>\n<select class="form-control" id="user_misc_3i" name="user[misc(3i)]">\n<option value="1">1</option>\n<option value="2">2</option>\n<option selected="selected" value="3">3</option>\n<option value="4">4</option>\n<option value="5">5</option>\n<option value="6">6</option>\n<option value="7">7</option>\n<option value="8">8</option>\n<option value="9">9</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.date_select(:misc)
    end
  end

  test "date selects with options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3)) do
      expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="rails-bootstrap-forms-date-select"><select class="form-control" id="user_misc_1i" name="user[misc(1i)]">\n<option value=""></option>\n<option value="2007">2007</option>\n<option value="2008">2008</option>\n<option value="2009">2009</option>\n<option value="2010">2010</option>\n<option value="2011">2011</option>\n<option value="2012">2012</option>\n<option value="2013">2013</option>\n<option value="2014">2014</option>\n<option value="2015">2015</option>\n<option value="2016">2016</option>\n<option value="2017">2017</option>\n</select>\n<select class="form-control" id="user_misc_2i" name="user[misc(2i)]">\n<option value=""></option>\n<option value="1">January</option>\n<option value="2">February</option>\n<option value="3">March</option>\n<option value="4">April</option>\n<option value="5">May</option>\n<option value="6">June</option>\n<option value="7">July</option>\n<option value="8">August</option>\n<option value="9">September</option>\n<option value="10">October</option>\n<option value="11">November</option>\n<option value="12">December</option>\n</select>\n<select class="form-control" id="user_misc_3i" name="user[misc(3i)]">\n<option value=""></option>\n<option value="1">1</option>\n<option value="2">2</option>\n<option value="3">3</option>\n<option value="4">4</option>\n<option value="5">5</option>\n<option value="6">6</option>\n<option value="7">7</option>\n<option value="8">8</option>\n<option value="9">9</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.date_select(:misc, include_blank: true)
    end
  end

  test "date selects with options and html_options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3)) do
      expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="rails-bootstrap-forms-date-select"><select class="form-control my-date-select" id="user_misc_1i" name="user[misc(1i)]">\n<option value=""></option>\n<option value="2007">2007</option>\n<option value="2008">2008</option>\n<option value="2009">2009</option>\n<option value="2010">2010</option>\n<option value="2011">2011</option>\n<option value="2012">2012</option>\n<option value="2013">2013</option>\n<option value="2014">2014</option>\n<option value="2015">2015</option>\n<option value="2016">2016</option>\n<option value="2017">2017</option>\n</select>\n<select class="form-control my-date-select" id="user_misc_2i" name="user[misc(2i)]">\n<option value=""></option>\n<option value="1">January</option>\n<option value="2">February</option>\n<option value="3">March</option>\n<option value="4">April</option>\n<option value="5">May</option>\n<option value="6">June</option>\n<option value="7">July</option>\n<option value="8">August</option>\n<option value="9">September</option>\n<option value="10">October</option>\n<option value="11">November</option>\n<option value="12">December</option>\n</select>\n<select class="form-control my-date-select" id="user_misc_3i" name="user[misc(3i)]">\n<option value=""></option>\n<option value="1">1</option>\n<option value="2">2</option>\n<option value="3">3</option>\n<option value="4">4</option>\n<option value="5">5</option>\n<option value="6">6</option>\n<option value="7">7</option>\n<option value="8">8</option>\n<option value="9">9</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.date_select(:misc, { include_blank: true }, class: "my-date-select")
    end
  end

  test "time selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="rails-bootstrap-forms-time-select"><input id="user_misc_1i" name="user[misc(1i)]" type="hidden" value="2012" />\n<input id="user_misc_2i" name="user[misc(2i)]" type="hidden" value="2" />\n<input id="user_misc_3i" name="user[misc(3i)]" type="hidden" value="3" />\n<select class="form-control" id="user_misc_4i" name="user[misc(4i)]">\n<option value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option selected="selected" value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n</select>\n : <select class="form-control" id="user_misc_5i" name="user[misc(5i)]">\n<option selected="selected" value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n<option value="32">32</option>\n<option value="33">33</option>\n<option value="34">34</option>\n<option value="35">35</option>\n<option value="36">36</option>\n<option value="37">37</option>\n<option value="38">38</option>\n<option value="39">39</option>\n<option value="40">40</option>\n<option value="41">41</option>\n<option value="42">42</option>\n<option value="43">43</option>\n<option value="44">44</option>\n<option value="45">45</option>\n<option value="46">46</option>\n<option value="47">47</option>\n<option value="48">48</option>\n<option value="49">49</option>\n<option value="50">50</option>\n<option value="51">51</option>\n<option value="52">52</option>\n<option value="53">53</option>\n<option value="54">54</option>\n<option value="55">55</option>\n<option value="56">56</option>\n<option value="57">57</option>\n<option value="58">58</option>\n<option value="59">59</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.time_select(:misc)
    end
  end

  test "time selects with options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="rails-bootstrap-forms-time-select"><input id="user_misc_1i" name="user[misc(1i)]" type="hidden" value="1" />\n<input id="user_misc_2i" name="user[misc(2i)]" type="hidden" value="1" />\n<input id="user_misc_3i" name="user[misc(3i)]" type="hidden" value="1" />\n<select class="form-control" id="user_misc_4i" name="user[misc(4i)]">\n<option value=""></option>\n<option value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n</select>\n : <select class="form-control" id="user_misc_5i" name="user[misc(5i)]">\n<option value=""></option>\n<option value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n<option value="32">32</option>\n<option value="33">33</option>\n<option value="34">34</option>\n<option value="35">35</option>\n<option value="36">36</option>\n<option value="37">37</option>\n<option value="38">38</option>\n<option value="39">39</option>\n<option value="40">40</option>\n<option value="41">41</option>\n<option value="42">42</option>\n<option value="43">43</option>\n<option value="44">44</option>\n<option value="45">45</option>\n<option value="46">46</option>\n<option value="47">47</option>\n<option value="48">48</option>\n<option value="49">49</option>\n<option value="50">50</option>\n<option value="51">51</option>\n<option value="52">52</option>\n<option value="53">53</option>\n<option value="54">54</option>\n<option value="55">55</option>\n<option value="56">56</option>\n<option value="57">57</option>\n<option value="58">58</option>\n<option value="59">59</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.time_select(:misc, include_blank: true)
    end
  end

  test "time selects with options and html_options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="rails-bootstrap-forms-time-select"><input id="user_misc_1i" name="user[misc(1i)]" type="hidden" value="1" />\n<input id="user_misc_2i" name="user[misc(2i)]" type="hidden" value="1" />\n<input id="user_misc_3i" name="user[misc(3i)]" type="hidden" value="1" />\n<select class="form-control my-time-select" id="user_misc_4i" name="user[misc(4i)]">\n<option value=""></option>\n<option value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n</select>\n : <select class="form-control my-time-select" id="user_misc_5i" name="user[misc(5i)]">\n<option value=""></option>\n<option value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n<option value="32">32</option>\n<option value="33">33</option>\n<option value="34">34</option>\n<option value="35">35</option>\n<option value="36">36</option>\n<option value="37">37</option>\n<option value="38">38</option>\n<option value="39">39</option>\n<option value="40">40</option>\n<option value="41">41</option>\n<option value="42">42</option>\n<option value="43">43</option>\n<option value="44">44</option>\n<option value="45">45</option>\n<option value="46">46</option>\n<option value="47">47</option>\n<option value="48">48</option>\n<option value="49">49</option>\n<option value="50">50</option>\n<option value="51">51</option>\n<option value="52">52</option>\n<option value="53">53</option>\n<option value="54">54</option>\n<option value="55">55</option>\n<option value="56">56</option>\n<option value="57">57</option>\n<option value="58">58</option>\n<option value="59">59</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.time_select(:misc, { include_blank: true }, class: "my-time-select")
    end
  end

  test "datetime selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="rails-bootstrap-forms-datetime-select"><select class="form-control" id="user_misc_1i" name="user[misc(1i)]">\n<option value="2007">2007</option>\n<option value="2008">2008</option>\n<option value="2009">2009</option>\n<option value="2010">2010</option>\n<option value="2011">2011</option>\n<option selected="selected" value="2012">2012</option>\n<option value="2013">2013</option>\n<option value="2014">2014</option>\n<option value="2015">2015</option>\n<option value="2016">2016</option>\n<option value="2017">2017</option>\n</select>\n<select class="form-control" id="user_misc_2i" name="user[misc(2i)]">\n<option value="1">January</option>\n<option selected="selected" value="2">February</option>\n<option value="3">March</option>\n<option value="4">April</option>\n<option value="5">May</option>\n<option value="6">June</option>\n<option value="7">July</option>\n<option value="8">August</option>\n<option value="9">September</option>\n<option value="10">October</option>\n<option value="11">November</option>\n<option value="12">December</option>\n</select>\n<select class="form-control" id="user_misc_3i" name="user[misc(3i)]">\n<option value="1">1</option>\n<option value="2">2</option>\n<option selected="selected" value="3">3</option>\n<option value="4">4</option>\n<option value="5">5</option>\n<option value="6">6</option>\n<option value="7">7</option>\n<option value="8">8</option>\n<option value="9">9</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n</select>\n &mdash; <select class="form-control" id="user_misc_4i" name="user[misc(4i)]">\n<option value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option selected="selected" value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n</select>\n : <select class="form-control" id="user_misc_5i" name="user[misc(5i)]">\n<option selected="selected" value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n<option value="32">32</option>\n<option value="33">33</option>\n<option value="34">34</option>\n<option value="35">35</option>\n<option value="36">36</option>\n<option value="37">37</option>\n<option value="38">38</option>\n<option value="39">39</option>\n<option value="40">40</option>\n<option value="41">41</option>\n<option value="42">42</option>\n<option value="43">43</option>\n<option value="44">44</option>\n<option value="45">45</option>\n<option value="46">46</option>\n<option value="47">47</option>\n<option value="48">48</option>\n<option value="49">49</option>\n<option value="50">50</option>\n<option value="51">51</option>\n<option value="52">52</option>\n<option value="53">53</option>\n<option value="54">54</option>\n<option value="55">55</option>\n<option value="56">56</option>\n<option value="57">57</option>\n<option value="58">58</option>\n<option value="59">59</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.datetime_select(:misc)
    end
  end

  test "datetime selects with options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="rails-bootstrap-forms-datetime-select"><select class="form-control" id="user_misc_1i" name="user[misc(1i)]">\n<option value=""></option>\n<option value="2007">2007</option>\n<option value="2008">2008</option>\n<option value="2009">2009</option>\n<option value="2010">2010</option>\n<option value="2011">2011</option>\n<option value="2012">2012</option>\n<option value="2013">2013</option>\n<option value="2014">2014</option>\n<option value="2015">2015</option>\n<option value="2016">2016</option>\n<option value="2017">2017</option>\n</select>\n<select class="form-control" id="user_misc_2i" name="user[misc(2i)]">\n<option value=""></option>\n<option value="1">January</option>\n<option value="2">February</option>\n<option value="3">March</option>\n<option value="4">April</option>\n<option value="5">May</option>\n<option value="6">June</option>\n<option value="7">July</option>\n<option value="8">August</option>\n<option value="9">September</option>\n<option value="10">October</option>\n<option value="11">November</option>\n<option value="12">December</option>\n</select>\n<select class="form-control" id="user_misc_3i" name="user[misc(3i)]">\n<option value=""></option>\n<option value="1">1</option>\n<option value="2">2</option>\n<option value="3">3</option>\n<option value="4">4</option>\n<option value="5">5</option>\n<option value="6">6</option>\n<option value="7">7</option>\n<option value="8">8</option>\n<option value="9">9</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n</select>\n &mdash; <select class="form-control" id="user_misc_4i" name="user[misc(4i)]">\n<option value=""></option>\n<option value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n</select>\n : <select class="form-control" id="user_misc_5i" name="user[misc(5i)]">\n<option value=""></option>\n<option value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n<option value="32">32</option>\n<option value="33">33</option>\n<option value="34">34</option>\n<option value="35">35</option>\n<option value="36">36</option>\n<option value="37">37</option>\n<option value="38">38</option>\n<option value="39">39</option>\n<option value="40">40</option>\n<option value="41">41</option>\n<option value="42">42</option>\n<option value="43">43</option>\n<option value="44">44</option>\n<option value="45">45</option>\n<option value="46">46</option>\n<option value="47">47</option>\n<option value="48">48</option>\n<option value="49">49</option>\n<option value="50">50</option>\n<option value="51">51</option>\n<option value="52">52</option>\n<option value="53">53</option>\n<option value="54">54</option>\n<option value="55">55</option>\n<option value="56">56</option>\n<option value="57">57</option>\n<option value="58">58</option>\n<option value="59">59</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.datetime_select(:misc, include_blank: true)
    end
  end

  test "datetime selects with options and html_options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="rails-bootstrap-forms-datetime-select"><select class="form-control my-datetime-select" id="user_misc_1i" name="user[misc(1i)]">\n<option value=""></option>\n<option value="2007">2007</option>\n<option value="2008">2008</option>\n<option value="2009">2009</option>\n<option value="2010">2010</option>\n<option value="2011">2011</option>\n<option value="2012">2012</option>\n<option value="2013">2013</option>\n<option value="2014">2014</option>\n<option value="2015">2015</option>\n<option value="2016">2016</option>\n<option value="2017">2017</option>\n</select>\n<select class="form-control my-datetime-select" id="user_misc_2i" name="user[misc(2i)]">\n<option value=""></option>\n<option value="1">January</option>\n<option value="2">February</option>\n<option value="3">March</option>\n<option value="4">April</option>\n<option value="5">May</option>\n<option value="6">June</option>\n<option value="7">July</option>\n<option value="8">August</option>\n<option value="9">September</option>\n<option value="10">October</option>\n<option value="11">November</option>\n<option value="12">December</option>\n</select>\n<select class="form-control my-datetime-select" id="user_misc_3i" name="user[misc(3i)]">\n<option value=""></option>\n<option value="1">1</option>\n<option value="2">2</option>\n<option value="3">3</option>\n<option value="4">4</option>\n<option value="5">5</option>\n<option value="6">6</option>\n<option value="7">7</option>\n<option value="8">8</option>\n<option value="9">9</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n</select>\n &mdash; <select class="form-control my-datetime-select" id="user_misc_4i" name="user[misc(4i)]">\n<option value=""></option>\n<option value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n</select>\n : <select class="form-control my-datetime-select" id="user_misc_5i" name="user[misc(5i)]">\n<option value=""></option>\n<option value="00">00</option>\n<option value="01">01</option>\n<option value="02">02</option>\n<option value="03">03</option>\n<option value="04">04</option>\n<option value="05">05</option>\n<option value="06">06</option>\n<option value="07">07</option>\n<option value="08">08</option>\n<option value="09">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n<option value="32">32</option>\n<option value="33">33</option>\n<option value="34">34</option>\n<option value="35">35</option>\n<option value="36">36</option>\n<option value="37">37</option>\n<option value="38">38</option>\n<option value="39">39</option>\n<option value="40">40</option>\n<option value="41">41</option>\n<option value="42">42</option>\n<option value="43">43</option>\n<option value="44">44</option>\n<option value="45">45</option>\n<option value="46">46</option>\n<option value="47">47</option>\n<option value="48">48</option>\n<option value="49">49</option>\n<option value="50">50</option>\n<option value="51">51</option>\n<option value="52">52</option>\n<option value="53">53</option>\n<option value="54">54</option>\n<option value="55">55</option>\n<option value="56">56</option>\n<option value="57">57</option>\n<option value="58">58</option>\n<option value="59">59</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.datetime_select(:misc, { include_blank: true }, class: "my-datetime-select")
    end
  end

  test "check_box is wrapped correctly" do
    expected = %{<div class="checkbox"><label for="user_terms"><input name="user[terms]" type="hidden" value="0" /><input id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms</label></div>}
    assert_equal expected, @builder.check_box(:terms, label: 'I agree to the terms')
  end

  test "check_box label allows html" do
    expected = %{<div class="checkbox"><label for="user_terms"><input name="user[terms]" type="hidden" value="0" /><input id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the <a href="#">terms</a></label></div>}
    assert_equal expected, @builder.check_box(:terms, label: %{I agree to the <a href="#">terms</a>}.html_safe)
  end

  test "check_box accepts a block to define the label" do
    expected = %{<div class="checkbox"><label for="user_terms"><input name="user[terms]" type="hidden" value="0" /><input id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms</label></div>}
    assert_equal expected, @builder.check_box(:terms) { "I agree to the terms" }
  end

  test "check_box responds to checked_value and unchecked_value arguments" do
    expected = %{<div class="checkbox"><label for="user_terms"><input name="user[terms]" type="hidden" value="no" /><input id="user_terms" name="user[terms]" type="checkbox" value="yes" /> I agree to the terms</label></div>}
    assert_equal expected, @builder.check_box(:terms, {label: 'I agree to the terms'}, 'yes', 'no')
  end

  test "inline checkboxes" do
    expected = %{<label class="checkbox-inline" for="user_terms"><input name="user[terms]" type="hidden" value="0" /><input id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms</label>}
    assert_equal expected, @builder.check_box(:terms, label: 'I agree to the terms', inline: true)
  end

  test "radio_button is wrapped correctly" do
    expected = %{<label class="radio"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> This is a radio button</label>}
    assert_equal expected, @builder.radio_button(:misc, '1', label: 'This is a radio button')
  end

  test "radio_button inline label is set correctly" do
    expected = %{<label class="radio-inline"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> This is a radio button</label>}
    assert_equal expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', inline: true)
  end

  test "changing the label text" do
    expected = %{<div class="form-group"><label class="control-label" for="user_email">Email Address</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equal expected, @builder.text_field(:email, label: 'Email Address')
  end

  test "hiding a label" do
    expected = %{<div class="form-group"><label class="sr-only control-label" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equal expected, @builder.text_field(:email, hide_label: true)
  end

  test "adding prepend text" do
    expected = %{<div class="form-group"><label class="control-label" for="user_email">Email</label><div class="input-group"><span class="input-group-addon">@</span><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div></div>}
    assert_equal expected, @builder.text_field(:email, prepend: '@')
  end

  test "adding append text" do
    expected = %{<div class="form-group"><label class="control-label" for="user_email">Email</label><div class="input-group"><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /><span class="input-group-addon">.00</span></div></div>}
    assert_equal expected, @builder.text_field(:email, append: '.00')
  end

  test "adding both prepend and append text" do
    expected = %{<div class="form-group"><label class="control-label" for="user_email">Email</label><div class="input-group"><span class="input-group-addon">$</span><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /><span class="input-group-addon">.00</span></div></div>}
    assert_equal expected, @builder.text_field(:email, prepend: '$', append: '.00')
  end

  test "help messages for default forms" do
    expected = %{<div class="form-group"><label class="control-label" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /><span class="help-block">This is required</span></div>}
    assert_equal expected, @builder.text_field(:email, help: 'This is required')
  end

  test "help messages for horizontal forms" do
    expected = %{<div class="form-group"><label class="control-label col-sm-2" for="user_email">Email</label><div class="col-sm-10"><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /><span class="help-block">This is required</span></div></div>}
    assert_equal expected, @horizontal_builder.text_field(:email, help: "This is required")
  end

  test "custom label width for horizontal forms" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="form-horizontal" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label col-sm-1" for="user_email">Email</label><div class="col-sm-10"><input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" /></div></div></form>}
    assert_equal expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, label_col: 'col-sm-1' }
  end

  test "custom input width for horizontal forms" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="form-horizontal" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label col-sm-2" for="user_email">Email</label><div class="col-sm-5"><input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" /></div></div></form>}
    assert_equal expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, control_col: 'col-sm-5' }
  end

  test "custom form group layout option" do
    expected = %{<form accept-charset="UTF-8" action="/users" class="form-horizontal" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" /></div></form>}
    assert_equal expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, layout: :inline }
  end

  test "passing options to a form control get passed through" do
    expected = %{<div class="form-group"><label class="control-label" for="user_email">Email</label><input autofocus="autofocus" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
    assert_equal expected, @builder.text_field(:email, autofocus: true)
  end

  test "form_group creates a valid structure and allows arbitrary html to be added via a block" do
    output = @horizontal_builder.form_group :nil, label: { text: 'Foo' } do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group"><label class="control-label col-sm-2" for="user_nil">Foo</label><div class="col-sm-10"><p class="form-control-static">Bar</p></div></div>}
    assert_equal expected, output
  end

  test "form_group adds a spacer when no label exists for a horizontal form" do
    output = @horizontal_builder.form_group do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group"><label class="control-label col-sm-2"></label><div class="col-sm-10"><p class="form-control-static">Bar</p></div></div>}
    assert_equal expected, output
  end

  test "form_group renders the label correctly" do
    output = @horizontal_builder.form_group :email, label: { text: 'Custom Control' } do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group"><label class="control-label col-sm-2" for="user_email">Custom Control</label><div class="col-sm-10"><p class="form-control-static">Bar</p></div></div>}
    assert_equal expected, output
  end

  test "form_group accepts class thorugh options hash" do
    output = @horizontal_builder.form_group :email, class: "foo" do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group foo"><label class="control-label col-sm-2"></label><div class="col-sm-10"><p class="form-control-static">Bar</p></div></div>}
    assert_equal expected, output
  end
  
  test "form_group accepts class thorugh options hash without needing a name" do
    output = @horizontal_builder.form_group class: "foo" do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group foo"><label class="control-label col-sm-2"></label><div class="col-sm-10"><p class="form-control-static">Bar</p></div></div>}
    assert_equal expected, output
  end

  test "static control" do
    output = @horizontal_builder.static_control :email

    expected = %{<div class="form-group"><label class="control-label col-sm-2" for="user_email">Email</label><div class="col-sm-10"><p class="form-control-static">steve@example.com</p></div></div>}
    assert_equal expected, output
  end

  test "static control doesn't require an actual attribute" do
    output = @horizontal_builder.static_control nil, label: "My Label" do
      "this is a test"
    end

    expected = %{<div class="form-group"><label class="control-label col-sm-2" for="user_">My Label</label><div class="col-sm-10"><p class="form-control-static">this is a test</p></div></div>}
    assert_equal expected, output
  end

  test "form_group overrides the label's 'class' and 'for' attributes if others are passed" do
    output = @horizontal_builder.form_group nil, label: { text: 'Custom Control', class: 'foo', for: 'bar' } do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group"><label class="foo control-label col-sm-2" for="bar">Custom Control</label><div class="col-sm-10"><p class="form-control-static">Bar</p></div></div>}
    assert_equal expected, output
  end

  test 'form_group renders the "error" class and message corrrectly when object is invalid' do
    @user.email = nil
    @user.valid?

    output = @builder.form_group :email do
      %{<p class="form-control-static">Bar</p>}.html_safe
    end

    expected = %{<div class="form-group has-error"><p class="form-control-static">Bar</p><span class="help-block">can&#39;t be blank, is too short (minimum is 5 characters)</span></div>}
    assert_equal expected, output
  end

  test "submit button defaults to rails action name" do
    expected = %{<input class="btn btn-default" name="commit" type="submit" value="Create User" />}
    assert_equal expected, @builder.submit
  end

  test "submit button uses default button classes" do
    expected = %{<input class="btn btn-default" name="commit" type="submit" value="Submit Form" />}
    assert_equal expected, @builder.submit("Submit Form")
  end

  test "override submit button classes" do
    expected = %{<input class="btn btn-primary" name="commit" type="submit" value="Submit Form" />}
    assert_equal expected, @builder.submit("Submit Form", class: "btn btn-primary")
  end

  test "primary button uses proper css classes" do
    expected = %{<input class="btn btn-primary" name="commit" type="submit" value="Submit Form" />}
    assert_equal expected, @builder.primary("Submit Form")
  end

  test "the field contains the error and is not wrapped in div.field_with_errors when bootstrap_form_for is used" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group has-error"><label class="control-label" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" /><span class="help-block">can&#39;t be blank, is too short (minimum is 5 characters)</span></div></form>}
    assert_equal expected, output
  end

  test "help is preserved when inline_errors: false is passed to bootstrap_form_for" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group has-error"><label class="control-label" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" /><span class="help-block">This is required</span></div></form>}
    assert_equal expected, output
  end

  test "the field is wrapped with div.field_with_errors when form_for is used" do
    @user.email = nil
    @user.valid?

    output = form_for(@user, builder: BootstrapForm::FormBuilder) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group has-error"><div class="field_with_errors"><label class="control-label" for="user_email">Email</label></div><div class="field_with_errors"><input class="form-control" id="user_email" name="user[email]" type="text" /></div><span class="help-block">can&#39;t be blank, is too short (minimum is 5 characters)</span></div></form>}
    assert_equal expected, output
  end

  test "bootstrap_form_for helper works for associations" do
    @user.address = Address.new(street: '123 Main Street')

    output = bootstrap_form_for(@user) do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label" for="user_address_attributes_street">Street</label><input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" /></div></form>}
    assert_equal expected, output
  end

  test "bootstrap_form_for helper works for serialized hash attributes" do
    @user.preferences = { favorite_color: "cerulean" }

    output = bootstrap_form_for(@user) do |f|
      f.fields_for :preferences do |builder|
        builder.text_field :favorite_color, value: @user.preferences[:favorite_color]
      end
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label" for="user_preferences_favorite_color">Favorite color</label><input class="form-control" id="user_preferences_favorite_color" name="user[preferences][favorite_color]" type="text" value="cerulean" /></div></form>}
    assert_equal expected, output
  end

  test "fields_for correctly passes horizontal style from parent builder" do
    @user.address = Address.new(street: '123 Main Street')

    output = bootstrap_form_for(@user, layout: :horizontal, label_col: 'col-sm-2', control_col: 'col-sm-10') do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="form-horizontal" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label col-sm-2" for="user_address_attributes_street">Street</label><div class="col-sm-10"><input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" /></div></div></form>}
    assert_equal expected, output
  end

  test "fields_for correctly passes inline style from parent builder" do
    @user.address = Address.new(street: '123 Main Street')

    output = bootstrap_form_for(@user, layout: :inline) do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = %{<form accept-charset="UTF-8" action="/users" class="form-inline" id="new_user" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="control-label" for="user_address_attributes_street">Street</label><input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" /></div></form>}
    assert_equal expected, output
  end

  test "allows the form object to be nil" do
    builder = BootstrapForm::FormBuilder.new :other_model, nil, self, {}
    expected = %{<div class="form-group"><label class="control-label" for="other_model_email">Email</label><input class="form-control" id="other_model_email" name="other_model[email]" type="text" /></div>}
    assert_equal expected, builder.text_field(:email)
  end

  test 'collection_radio_buttons renders the form_group correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">This is a radio button collection</label><label class="radio"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foobar</label><span class="help-block">With a help!</span></div>}

    assert_equal expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders multiple radios correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><label class="radio"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foo</label><label class="radio"><input id="user_misc_2" name="user[misc]" type="radio" value="2" /> Bar</label></div>}

    assert_equal expected, @builder.collection_radio_buttons(:misc, collection, :id, :street)
  end

  test 'collection_radio_buttons renders inline radios correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><label class="radio-inline"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foo</label><label class="radio-inline"><input id="user_misc_2" name="user[misc]" type="radio" value="2" /> Bar</label></div>}

    assert_equal expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, inline: true)
  end

  test 'collection_radio_buttons renders with checked option correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><label class="radio"><input checked="checked" id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foo</label><label class="radio"><input id="user_misc_2" name="user[misc]" type="radio" value="2" /> Bar</label></div>}

    assert_equal expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, checked: 1)
  end

  test 'collection_check_boxes renders the form_group correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">This is a checkbox collection</label><div class="checkbox"><label for="user_misc_1"><input id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foobar</label></div><span class="help-block">With a help!</span></div>}

    assert_equal expected, @builder.collection_check_boxes(:misc, collection, :id, :street, label: 'This is a checkbox collection', help: 'With a help!')
  end

  test 'collection_check_boxes renders multiple checkboxes correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="checkbox"><label for="user_misc_1"><input id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foo</label></div><div class="checkbox"><label for="user_misc_2"><input id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> Bar</label></div></div>}

    assert_equal expected, @builder.collection_check_boxes(:misc, collection, :id, :street)
  end

  test 'collection_check_boxes renders inline checkboxes correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><label class="checkbox-inline" for="user_misc_1"><input id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foo</label><label class="checkbox-inline" for="user_misc_2"><input id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> Bar</label></div>}

    assert_equal expected, @builder.collection_check_boxes(:misc, collection, :id, :street, inline: true)
  end

  test 'collection_check_boxes renders with checked option correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="checkbox"><label for="user_misc_1"><input checked="checked" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foo</label></div><div class="checkbox"><label for="user_misc_2"><input id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> Bar</label></div></div>}

    assert_equal expected, @builder.collection_check_boxes(:misc, collection, :id, :street, checked: 1)
  end

end
