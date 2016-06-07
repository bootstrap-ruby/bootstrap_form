require 'test_helper'

class BootstrapFieldsTest < ActionView::TestCase
  include BootstrapForm::Helper

  def setup
    setup_test_fixture
  end

  test "color fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" value="#000000" type="color" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.color_field(:misc)
  end

  test "date fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="date" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.date_field(:misc)
  end

  test "date time fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="datetime" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.datetime_field(:misc)
  end

  test "date time local fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="datetime-local" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.datetime_local_field(:misc)
  end

  test "email fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="email" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.email_field(:misc)
  end

  test "file fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input name="user[misc]" type="hidden" value="" /><input name="user[misc]" id="user_misc" type="file" /></div>}
    assert_equal expected, @builder.file_field(:misc)
  end

  test "hidden fields are supported" do
    expected = %{<input type="hidden" name="user[misc]" id="user_misc" />}
    assert_equal expected, @builder.hidden_field(:misc)
  end

  test "month local fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="month" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.month_field(:misc)
  end

  test "number fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="number" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.number_field(:misc)
  end

  test "password fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_password">Password</label><input class="form-control" type="password" name="user[password]" id="user_password" /><span class="help-block">A good password should be at least six characters long</span></div>}
    assert_equal expected, @builder.password_field(:password)
  end

  test "phone/telephone fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="tel" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.phone_field(:misc)
    assert_equal expected, @builder.telephone_field(:misc)
  end

  test "range fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="range" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.range_field(:misc)
  end

  test "search fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="search" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.search_field(:misc)
  end

  test "text areas are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_comments">Comments</label><textarea class="form-control" name="user[comments]" id="user_comments">\nmy comment</textarea></div>}
    assert_equal expected, @builder.text_area(:comments)
  end

  test "text fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label required" for="user_email">Email</label><input class="form-control" type="text" value="steve@example.com" name="user[email]" id="user_email" /></div>}
    assert_equal expected, @builder.text_field(:email)
  end

  test "time fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="time" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.time_field(:misc)
  end

  test "url fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="url" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.url_field(:misc)
  end

  test "week fields are wrapped correctly" do
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><input class="form-control" type="week" name="user[misc]" id="user_misc" /></div>}
    assert_equal expected, @builder.week_field(:misc)
  end

  test "bootstrap_form_for helper works for associations" do
    @user.address = Address.new(street: '123 Main Street')

    output = bootstrap_form_for(@user) do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = %{<form role="form" class="new_user" id="new_user" action="/users" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><div class="form-group"><label class="control-label" for="user_address_attributes_street">Street</label><input class="form-control" type="text" value="123 Main Street" name="user[address_attributes][street]" id="user_address_attributes_street" /></div></form>}
    assert_equal expected, output
  end

  test "bootstrap_form_for helper works for serialized hash attributes" do
    @user.preferences = { favorite_color: "cerulean" }

    output = bootstrap_form_for(@user) do |f|
      f.fields_for :preferences do |builder|
        builder.text_field :favorite_color, value: @user.preferences[:favorite_color]
      end
    end

    expected = %{<form role="form" class="new_user" id="new_user" action="/users" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><div class="form-group"><label class="control-label" for="user_preferences_favorite_color">Favorite color</label><input value="cerulean" class="form-control" type="text" name="user[preferences][favorite_color]" id="user_preferences_favorite_color" /></div></form>}
    assert_equal expected, output
  end

  test "fields_for correctly passes horizontal style from parent builder" do
    @user.address = Address.new(street: '123 Main Street')

    output = bootstrap_form_for(@user, layout: :horizontal, label_col: 'col-sm-2', control_col: 'col-sm-10') do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = %{<form role="form" class="form-horizontal" id="new_user" action="/users" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><div class="form-group"><label class="control-label col-sm-2" for="user_address_attributes_street">Street</label><div class="col-sm-10"><input class="form-control" type="text" value="123 Main Street" name="user[address_attributes][street]" id="user_address_attributes_street" /></div></div></form>}
    assert_equal expected, output
  end

  test "fields_for correctly passes inline style from parent builder" do
    @user.address = Address.new(street: '123 Main Street')

    output = bootstrap_form_for(@user, layout: :inline) do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = %{<form role="form" class="form-inline" id="new_user" action="/users" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><div class="form-group"><label class="control-label" for="user_address_attributes_street">Street</label><input class="form-control" type="text" value="123 Main Street" name="user[address_attributes][street]" id="user_address_attributes_street" /></div></form>}
    assert_equal expected, output
  end
end
