require 'test_helper'

class BootstrapFormTest < ActionView::TestCase
  include BootstrapForm::Helper

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
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><input id=\"user_email\" name=\"user[email]\" type=\"text\" value=\"steve@example.com\" /></div></div>}
    assert_equal expected, @builder.text_field(:email)
  end

  test "password fields are wrapped correctly" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_password\">Password</label><div class=\"controls\"><input id=\"user_password\" name=\"user[password]\" type=\"text\" value=\"secret\" /></div></div>}
    assert_equal expected, @builder.text_field(:password)
  end

  test "text areas are wrapped correctly" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_comments\">Comments</label><div class=\"controls\"><textarea id=\"user_comments\" name=\"user[comments]\">\nmy comment</textarea></div></div>}
    assert_equal expected, @builder.text_area(:comments)
  end

  test "file fields are wrapped correctly" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_misc\">Misc</label><div class=\"controls\"><input id=\"user_misc\" name=\"user[misc]\" type=\"file\" /></div></div>}
    assert_equal expected, @builder.file_field(:misc)
  end

  test "number fields are wrapped correctly" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_misc\">Misc</label><div class=\"controls\"><input id=\"user_misc\" name=\"user[misc]\" type=\"number\" /></div></div>}
    assert_equal expected, @builder.number_field(:misc)
  end

  test "email fields are wrapped correctly" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_misc\">Misc</label><div class=\"controls\"><input id=\"user_misc\" name=\"user[misc]\" type=\"email\" /></div></div>}
    assert_equal expected, @builder.email_field(:misc)
  end

  test "telephone/phone fields are wrapped correctly" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_misc\">Misc</label><div class=\"controls\"><input id=\"user_misc\" name=\"user[misc]\" type=\"tel\" /></div></div>}
    assert_equal expected, @builder.telephone_field(:misc)
    assert_equal expected, @builder.phone_field(:misc)
  end

  test "url fields are wrapped correctly" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_misc\">Misc</label><div class=\"controls\"><input id=\"user_misc\" name=\"user[misc]\" type=\"url\" /></div></div>}
    assert_equal expected, @builder.url_field(:misc)
  end

  test "selects are wrapped correctly (select)" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_status\">Status</label><div class=\"controls\"><select id=\"user_status\" name=\"user[status]\"><option value=\"1\">activated</option>\n<option value=\"2\">blocked</option></select></div></div>}
    assert_equal expected, @builder.select(:status, [['activated', 1], ['blocked', 2]])
  end

  test "selects are wrapped correctly (collection_select)" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_status\">Status</label><div class=\"controls\"><select id=\"user_status\" name=\"user[status]\"></select></div></div>}
    assert_equal expected, @builder.collection_select(:status, [], :id, :name)
  end

  test "date selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3)) do
      expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_misc\">Misc</label><div class=\"controls\"><select id=\"user_misc_1i\" name=\"user[misc(1i)]\">\n<option value=\"2007\">2007</option>\n<option value=\"2008\">2008</option>\n<option value=\"2009\">2009</option>\n<option value=\"2010\">2010</option>\n<option value=\"2011\">2011</option>\n<option selected=\"selected\" value=\"2012\">2012</option>\n<option value=\"2013\">2013</option>\n<option value=\"2014\">2014</option>\n<option value=\"2015\">2015</option>\n<option value=\"2016\">2016</option>\n<option value=\"2017\">2017</option>\n</select>\n<select id=\"user_misc_2i\" name=\"user[misc(2i)]\">\n<option value=\"1\">January</option>\n<option selected=\"selected\" value=\"2\">February</option>\n<option value=\"3\">March</option>\n<option value=\"4\">April</option>\n<option value=\"5\">May</option>\n<option value=\"6\">June</option>\n<option value=\"7\">July</option>\n<option value=\"8\">August</option>\n<option value=\"9\">September</option>\n<option value=\"10\">October</option>\n<option value=\"11\">November</option>\n<option value=\"12\">December</option>\n</select>\n<select id=\"user_misc_3i\" name=\"user[misc(3i)]\">\n<option value=\"1\">1</option>\n<option value=\"2\">2</option>\n<option selected=\"selected\" value=\"3\">3</option>\n<option value=\"4\">4</option>\n<option value=\"5\">5</option>\n<option value=\"6\">6</option>\n<option value=\"7\">7</option>\n<option value=\"8\">8</option>\n<option value=\"9\">9</option>\n<option value=\"10\">10</option>\n<option value=\"11\">11</option>\n<option value=\"12\">12</option>\n<option value=\"13\">13</option>\n<option value=\"14\">14</option>\n<option value=\"15\">15</option>\n<option value=\"16\">16</option>\n<option value=\"17\">17</option>\n<option value=\"18\">18</option>\n<option value=\"19\">19</option>\n<option value=\"20\">20</option>\n<option value=\"21\">21</option>\n<option value=\"22\">22</option>\n<option value=\"23\">23</option>\n<option value=\"24\">24</option>\n<option value=\"25\">25</option>\n<option value=\"26\">26</option>\n<option value=\"27\">27</option>\n<option value=\"28\">28</option>\n<option value=\"29\">29</option>\n<option value=\"30\">30</option>\n<option value=\"31\">31</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.date_select(:misc)
    end
  end

  test "time selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_misc\">Misc</label><div class=\"controls\"><input id=\"user_misc_1i\" name=\"user[misc(1i)]\" type=\"hidden\" value=\"2012\" />\n<input id=\"user_misc_2i\" name=\"user[misc(2i)]\" type=\"hidden\" value=\"2\" />\n<input id=\"user_misc_3i\" name=\"user[misc(3i)]\" type=\"hidden\" value=\"3\" />\n<select id=\"user_misc_4i\" name=\"user[misc(4i)]\">\n<option value=\"00\">00</option>\n<option value=\"01\">01</option>\n<option value=\"02\">02</option>\n<option value=\"03\">03</option>\n<option value=\"04\">04</option>\n<option value=\"05\">05</option>\n<option value=\"06\">06</option>\n<option value=\"07\">07</option>\n<option value=\"08\">08</option>\n<option value=\"09\">09</option>\n<option value=\"10\">10</option>\n<option value=\"11\">11</option>\n<option selected=\"selected\" value=\"12\">12</option>\n<option value=\"13\">13</option>\n<option value=\"14\">14</option>\n<option value=\"15\">15</option>\n<option value=\"16\">16</option>\n<option value=\"17\">17</option>\n<option value=\"18\">18</option>\n<option value=\"19\">19</option>\n<option value=\"20\">20</option>\n<option value=\"21\">21</option>\n<option value=\"22\">22</option>\n<option value=\"23\">23</option>\n</select>\n : <select id=\"user_misc_5i\" name=\"user[misc(5i)]\">\n<option selected=\"selected\" value=\"00\">00</option>\n<option value=\"01\">01</option>\n<option value=\"02\">02</option>\n<option value=\"03\">03</option>\n<option value=\"04\">04</option>\n<option value=\"05\">05</option>\n<option value=\"06\">06</option>\n<option value=\"07\">07</option>\n<option value=\"08\">08</option>\n<option value=\"09\">09</option>\n<option value=\"10\">10</option>\n<option value=\"11\">11</option>\n<option value=\"12\">12</option>\n<option value=\"13\">13</option>\n<option value=\"14\">14</option>\n<option value=\"15\">15</option>\n<option value=\"16\">16</option>\n<option value=\"17\">17</option>\n<option value=\"18\">18</option>\n<option value=\"19\">19</option>\n<option value=\"20\">20</option>\n<option value=\"21\">21</option>\n<option value=\"22\">22</option>\n<option value=\"23\">23</option>\n<option value=\"24\">24</option>\n<option value=\"25\">25</option>\n<option value=\"26\">26</option>\n<option value=\"27\">27</option>\n<option value=\"28\">28</option>\n<option value=\"29\">29</option>\n<option value=\"30\">30</option>\n<option value=\"31\">31</option>\n<option value=\"32\">32</option>\n<option value=\"33\">33</option>\n<option value=\"34\">34</option>\n<option value=\"35\">35</option>\n<option value=\"36\">36</option>\n<option value=\"37\">37</option>\n<option value=\"38\">38</option>\n<option value=\"39\">39</option>\n<option value=\"40\">40</option>\n<option value=\"41\">41</option>\n<option value=\"42\">42</option>\n<option value=\"43\">43</option>\n<option value=\"44\">44</option>\n<option value=\"45\">45</option>\n<option value=\"46\">46</option>\n<option value=\"47\">47</option>\n<option value=\"48\">48</option>\n<option value=\"49\">49</option>\n<option value=\"50\">50</option>\n<option value=\"51\">51</option>\n<option value=\"52\">52</option>\n<option value=\"53\">53</option>\n<option value=\"54\">54</option>\n<option value=\"55\">55</option>\n<option value=\"56\">56</option>\n<option value=\"57\">57</option>\n<option value=\"58\">58</option>\n<option value=\"59\">59</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.time_select(:misc)
    end
  end

  test "datetime selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_misc\">Misc</label><div class=\"controls\"><select id=\"user_misc_1i\" name=\"user[misc(1i)]\">\n<option value=\"2007\">2007</option>\n<option value=\"2008\">2008</option>\n<option value=\"2009\">2009</option>\n<option value=\"2010\">2010</option>\n<option value=\"2011\">2011</option>\n<option selected=\"selected\" value=\"2012\">2012</option>\n<option value=\"2013\">2013</option>\n<option value=\"2014\">2014</option>\n<option value=\"2015\">2015</option>\n<option value=\"2016\">2016</option>\n<option value=\"2017\">2017</option>\n</select>\n<select id=\"user_misc_2i\" name=\"user[misc(2i)]\">\n<option value=\"1\">January</option>\n<option selected=\"selected\" value=\"2\">February</option>\n<option value=\"3\">March</option>\n<option value=\"4\">April</option>\n<option value=\"5\">May</option>\n<option value=\"6\">June</option>\n<option value=\"7\">July</option>\n<option value=\"8\">August</option>\n<option value=\"9\">September</option>\n<option value=\"10\">October</option>\n<option value=\"11\">November</option>\n<option value=\"12\">December</option>\n</select>\n<select id=\"user_misc_3i\" name=\"user[misc(3i)]\">\n<option value=\"1\">1</option>\n<option value=\"2\">2</option>\n<option selected=\"selected\" value=\"3\">3</option>\n<option value=\"4\">4</option>\n<option value=\"5\">5</option>\n<option value=\"6\">6</option>\n<option value=\"7\">7</option>\n<option value=\"8\">8</option>\n<option value=\"9\">9</option>\n<option value=\"10\">10</option>\n<option value=\"11\">11</option>\n<option value=\"12\">12</option>\n<option value=\"13\">13</option>\n<option value=\"14\">14</option>\n<option value=\"15\">15</option>\n<option value=\"16\">16</option>\n<option value=\"17\">17</option>\n<option value=\"18\">18</option>\n<option value=\"19\">19</option>\n<option value=\"20\">20</option>\n<option value=\"21\">21</option>\n<option value=\"22\">22</option>\n<option value=\"23\">23</option>\n<option value=\"24\">24</option>\n<option value=\"25\">25</option>\n<option value=\"26\">26</option>\n<option value=\"27\">27</option>\n<option value=\"28\">28</option>\n<option value=\"29\">29</option>\n<option value=\"30\">30</option>\n<option value=\"31\">31</option>\n</select>\n &mdash; <select id=\"user_misc_4i\" name=\"user[misc(4i)]\">\n<option value=\"00\">00</option>\n<option value=\"01\">01</option>\n<option value=\"02\">02</option>\n<option value=\"03\">03</option>\n<option value=\"04\">04</option>\n<option value=\"05\">05</option>\n<option value=\"06\">06</option>\n<option value=\"07\">07</option>\n<option value=\"08\">08</option>\n<option value=\"09\">09</option>\n<option value=\"10\">10</option>\n<option value=\"11\">11</option>\n<option selected=\"selected\" value=\"12\">12</option>\n<option value=\"13\">13</option>\n<option value=\"14\">14</option>\n<option value=\"15\">15</option>\n<option value=\"16\">16</option>\n<option value=\"17\">17</option>\n<option value=\"18\">18</option>\n<option value=\"19\">19</option>\n<option value=\"20\">20</option>\n<option value=\"21\">21</option>\n<option value=\"22\">22</option>\n<option value=\"23\">23</option>\n</select>\n : <select id=\"user_misc_5i\" name=\"user[misc(5i)]\">\n<option selected=\"selected\" value=\"00\">00</option>\n<option value=\"01\">01</option>\n<option value=\"02\">02</option>\n<option value=\"03\">03</option>\n<option value=\"04\">04</option>\n<option value=\"05\">05</option>\n<option value=\"06\">06</option>\n<option value=\"07\">07</option>\n<option value=\"08\">08</option>\n<option value=\"09\">09</option>\n<option value=\"10\">10</option>\n<option value=\"11\">11</option>\n<option value=\"12\">12</option>\n<option value=\"13\">13</option>\n<option value=\"14\">14</option>\n<option value=\"15\">15</option>\n<option value=\"16\">16</option>\n<option value=\"17\">17</option>\n<option value=\"18\">18</option>\n<option value=\"19\">19</option>\n<option value=\"20\">20</option>\n<option value=\"21\">21</option>\n<option value=\"22\">22</option>\n<option value=\"23\">23</option>\n<option value=\"24\">24</option>\n<option value=\"25\">25</option>\n<option value=\"26\">26</option>\n<option value=\"27\">27</option>\n<option value=\"28\">28</option>\n<option value=\"29\">29</option>\n<option value=\"30\">30</option>\n<option value=\"31\">31</option>\n<option value=\"32\">32</option>\n<option value=\"33\">33</option>\n<option value=\"34\">34</option>\n<option value=\"35\">35</option>\n<option value=\"36\">36</option>\n<option value=\"37\">37</option>\n<option value=\"38\">38</option>\n<option value=\"39\">39</option>\n<option value=\"40\">40</option>\n<option value=\"41\">41</option>\n<option value=\"42\">42</option>\n<option value=\"43\">43</option>\n<option value=\"44\">44</option>\n<option value=\"45\">45</option>\n<option value=\"46\">46</option>\n<option value=\"47\">47</option>\n<option value=\"48\">48</option>\n<option value=\"49\">49</option>\n<option value=\"50\">50</option>\n<option value=\"51\">51</option>\n<option value=\"52\">52</option>\n<option value=\"53\">53</option>\n<option value=\"54\">54</option>\n<option value=\"55\">55</option>\n<option value=\"56\">56</option>\n<option value=\"57\">57</option>\n<option value=\"58\">58</option>\n<option value=\"59\">59</option>\n</select>\n</div></div>}
      assert_equal expected, @builder.datetime_select(:misc)
    end
  end

  test "check_box is wrapped correctly" do
    expected = %{<label class=\"checkbox\" for=\"user_misc\"><input name=\"user[misc]\" type=\"hidden\" value=\"0\" /><input id=\"user_misc\" name=\"user[misc]\" type=\"checkbox\" value=\"1\" /> This is a checkbox</label>}
    assert_equal expected, @builder.check_box(:misc, label: 'This is a checkbox')
  end

  test "check_box responds to checked_value and unchecked_value arguments" do
    expected = %{<label class=\"checkbox\" for=\"user_misc\"><input name=\"user[misc]\" type=\"hidden\" value=\"no\" /><input id=\"user_misc\" name=\"user[misc]\" type=\"checkbox\" value=\"yes\" /> This is a checkbox</label>}
    assert_equal expected, @builder.check_box(:misc, {label: 'This is a checkbox'}, 'yes', 'no')
  end

  test "check_box inline label is setted correctly" do
    expected = %{<label class=\"checkbox inline\" for=\"user_misc\"><input name=\"user[misc]\" type=\"hidden\" value=\"0\" /><input id=\"user_misc\" name=\"user[misc]\" type=\"checkbox\" value=\"1\" /> This is a checkbox</label>}
    assert_equal expected, @builder.check_box(:misc, label: 'This is a checkbox', inline: true)
  end

  test "radio_button is wrapped correctly" do
    expected = %{<label class=\"radio\" for=\"user_misc_1\"><input id=\"user_misc_1\" name=\"user[misc]\" type=\"radio\" value=\"1\" /> This is a radio button</label>}
    assert_equal expected, @builder.radio_button(:misc, '1', label: 'This is a radio button')
  end

  test "radio_button inline label is setted correctly" do
    expected = %{<label class=\"radio inline\" for=\"user_misc_1\"><input id=\"user_misc_1\" name=\"user[misc]\" type=\"radio\" value=\"1\" /> This is a radio button</label>}
    assert_equal expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', inline: true)
  end

  test "changing the label text" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email Address</label><div class=\"controls\"><input id=\"user_email\" name=\"user[email]\" type=\"text\" value=\"steve@example.com\" /></div></div>}
    assert_equal expected, @builder.text_field(:email, label: 'Email Address')
  end

  test "render the field without label" do
    expected = %{<div class=\"control-group\"><div class=\"controls\"><input id=\"user_email\" name=\"user[email]\" type=\"text\" value=\"steve@example.com\" /></div></div>}
    assert_equal expected, @builder.text_field(:email, label: :none)
  end

  test "adding prepend text" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><div class=\"input-prepend\"><span class=\"add-on\">Gmail</span><input id=\"user_email\" name=\"user[email]\" type=\"text\" value=\"steve@example.com\" /></div></div></div>}
    assert_equal expected, @builder.text_field(:email, prepend: 'Gmail')
  end

  test "adding append text" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><div class=\"input-append\"><input id=\"user_email\" name=\"user[email]\" type=\"text\" value=\"steve@example.com\" /><span class="add-on">Gmail</span></div></div></div>}
    assert_equal expected, @builder.text_field(:email, append: 'Gmail')
  end

  test "passing :help to a field displays it inline" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><input id=\"user_email\" name=\"user[email]\" type=\"text\" value=\"steve@example.com\" /><span class=\"help-inline\">This is required</span></div></div>}
    assert_equal expected, @builder.text_field(:email, help: 'This is required')
  end

  test "passing other options to a field get passed through" do
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><input autofocus=\"autofocus\" id=\"user_email\" name=\"user[email]\" type=\"text\" value=\"steve@example.com\" /></div></div>}
    assert_equal expected, @builder.text_field(:email, autofocus: true)
  end

  test "control_group creates a valid structure and allows arbitrary html to be added via a block" do
    output = @builder.control_group do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="control-group"><div class="controls"><span>custom control here</span></div></div>}
    assert_equal expected, output
  end

  test "control_group renders the options for div.control_group" do
    output = @builder.control_group nil, id: 'foo' do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="control-group" id="foo"><div class="controls"><span>custom control here</span></div></div>}
    assert_equal expected, output
  end

  test "control_group overrides the control-group class if another is passed" do
    output = @builder.control_group nil, class: 'foo' do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="foo"><div class="controls"><span>custom control here</span></div></div>}
    assert_equal expected, output
  end

  test "control_group renders the label correctly" do
    output = @builder.control_group :email, label: { text: 'Custom Control' } do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="control-group"><label class="control-label" for="user_email">Custom Control</label><div class="controls"><span>custom control here</span></div></div>}
    assert_equal expected, output
  end

  test "control_group overrides the label's 'class' and 'for' attributes if others are passed" do
    output = @builder.control_group nil, label: { text: 'Custom Control', class: 'foo', for: 'bar' } do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="control-group"><label class="foo" for="bar">Custom Control</label><div class="controls"><span>custom control here</span></div></div>}
    assert_equal expected, output
  end

  test "control_group label's 'for' attribute should be empty if no name was passed" do
    output = @builder.control_group nil, label: { text: 'Custom Control' } do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="control-group"><label class="control-label" for="">Custom Control</label><div class="controls"><span>custom control here</span></div></div>}
    assert_equal expected, output
  end

  test 'control_group renders the :help corrrectly' do
    output = @builder.control_group nil, help: 'Foobar' do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="control-group"><div class="controls"><span>custom control here</span><span class="help-inline">Foobar</span></div></div>}
    assert_equal expected, output
  end

  test 'control_group renders the "error" class and message corrrectly when object is invalid' do
    @user.email = nil
    @user.valid?

    output = @builder.control_group :email do
      content_tag(:span, 'custom control here')
    end

    expected = %{<div class="control-group error"><div class="controls"><span>custom control here</span><span class="help-inline">can&#39;t be blank, is too short (minimum is 5 characters)</span></div></div>}
    assert_equal expected, output
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
    assert_equal expected, @builder.primary('Submit', data: { disable_with: 'Saving...' })
  end

  test "secondary button contains the correct classes" do
    expected = %{<input class=\"btn\" name=\"commit\" type=\"submit\" value=\"Submit\" />}
    assert_equal expected, @builder.secondary('Submit')
  end

  test "secondary button with a disabled state" do
    expected = %{<input class=\"btn\" data-disable-with="Saving..." name=\"commit\" type=\"submit\" value=\"Submit\" />}
    assert_equal expected, @builder.secondary('Submit', data: { disable_with: 'Saving...' })
  end

  test "passing :help :block to the form builder" do
    output = bootstrap_form_for(@user, help: :block) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\" form-vertical\" id=\"new_user\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><div class=\"control-group\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><input id=\"user_email\" name=\"user[email]\" type=\"text\" value=\"steve@example.com\" /><span class=\"help-block\">This is required</span></div></div></form>}
    assert_equal expected, output
  end

  test "the field contains the error and is not wrapped in div.field_with_errors when bootstrap_form_for is used" do
    @user.email = nil
    @user.valid?

    output = bootstrap_form_for(@user, help: :block) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\" form-vertical\" id=\"new_user\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><div class=\"control-group error\"><label class=\"control-label\" for=\"user_email\">Email</label><div class=\"controls\"><input id=\"user_email\" name=\"user[email]\" type=\"text\" /><span class=\"help-block\">can&#39;t be blank, is too short (minimum is 5 characters)</span></div></div></form>}
    assert_equal expected, output
  end

  test "the field is wrapped with div.field_with_errors when form_for is used" do
    @user.email = nil
    @user.valid?

    output = form_for(@user, builder: BootstrapForm::FormBuilder, help: :block) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\"new_user\" id=\"new_user\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><div class=\"control-group error\"><div class=\"field_with_errors\"><label class=\"control-label\" for=\"user_email\">Email</label></div><div class=\"controls\"><div class=\"field_with_errors\"><input id=\"user_email\" name=\"user[email]\" type=\"text\" /></div><span class=\"help-block\">can&#39;t be blank, is too short (minimum is 5 characters)</span></div></div></form>}
    assert_equal expected, output
  end

  test "form_for helper works for associations" do
    @user.address = Address.new(street: '123 Main Street')

    output = bootstrap_form_for(@user) do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = %{<form accept-charset=\"UTF-8\" action=\"/users\" class=\" form-vertical\" id=\"new_user\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><div class=\"control-group\"><label class=\"control-label\" for=\"user_address_attributes_street\">Street</label><div class=\"controls\"><input id=\"user_address_attributes_street\" name=\"user[address_attributes][street]\" type=\"text\" value=\"123 Main Street\" /></div></div></form>}
    assert_equal expected, output
  end

  test "allows the form object to be nil" do
    builder = BootstrapForm::FormBuilder.new :other_model, nil, self, {}, nil
    expected = %{<div class=\"control-group\"><label class=\"control-label\" for=\"other_model_email\">Email</label><div class=\"controls\"><input id=\"other_model_email\" name=\"other_model[email]\" type=\"text\" /></div></div>}
    assert_equal expected, builder.text_field(:email)
  end
end

