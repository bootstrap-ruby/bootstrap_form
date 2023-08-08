require_relative "test_helper"

class BootstrapFieldsTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  test "color fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="color" value="#000000" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.color_field(:misc)
  end

  test "date fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" extra="extra arg" id="user_misc" name="user[misc]" type="date" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.date_field(:misc, extra: "extra arg")
  end

  test "date time fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="datetime" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.datetime_field(:misc)
  end

  test "date time local fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="datetime-local" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.datetime_local_field(:misc)
  end

  test "email fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="email" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.email_field(:misc)
  end

  test "file fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="file"/>
      </div>
    HTML
    assert_equivalent_html expected, @builder.file_field(:misc)
  end

  test "file field placeholder can be customized" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" placeholder="Pick a file" type="file"/>
      </div>
    HTML
    assert_equivalent_html expected, @builder.file_field(:misc, placeholder: "Pick a file")
  end

  test "file field placeholder has appropriate `for` attribute when used in form_with" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="custom-id">Misc</label>
        <input class="form-control" id="custom-id" name="user[misc]" type="file"/>
      </div>
    HTML
    assert_equivalent_html expected, form_with_builder.file_field(:misc, id: "custom-id")
  end

  test "file fields are wrapped correctly with error" do
    @user.errors.add(:misc, "error for test")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" enctype="multipart/form-data" id="new_user" method="post">
        #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <input class="form-control is-invalid" id="user_misc" name="user[misc]" type="file"/>
          <div class="invalid-feedback">error for test</div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |f| f.file_field(:misc) }
  end

  test "hidden fields are supported" do
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc]" type="hidden" />
    HTML
    assert_equivalent_html expected, @builder.hidden_field(:misc)
  end

  test "month local fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="month" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.month_field(:misc)
  end

  test "number fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="number" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.number_field(:misc)
  end

  test "password fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_password">Password</label>
        <input class="form-control" id="user_password" name="user[password]" type="password" />
        <small class="form-text text-muted">A good password should be at least six characters long</small>
      </div>
    HTML
    assert_equivalent_html expected, @builder.password_field(:password)
  end

  test "phone/telephone fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="tel" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.phone_field(:misc)
    assert_equivalent_html expected, @builder.telephone_field(:misc)
  end

  test "range fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-range" id="user_misc" name="user[misc]" type="range" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.range_field(:misc)
  end

  test "search fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="search" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.search_field(:misc)
  end

  test "text areas are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_comments">Comments</label>
        <textarea class="form-control" id="user_comments" name="user[comments]">\nmy comment</textarea>
      </div>
    HTML
    assert_equivalent_html expected, @builder.text_area(:comments)
  end

  test "text areas are wrapped correctly using form_with" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_comments">Comments</label>
        <textarea class="form-control" id="user_comments" name="user[comments]">\nmy comment</textarea>
      </div>
    HTML
    assert_equivalent_html expected, form_with_builder.text_area(:comments)
  end

  test "text fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label required" for="user_email">Email</label>
        <input aria-required="true" required="required" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.text_field(:email)
  end

  test "text fields are wrapped correctly when horizontal and gutter classes are given" do
    expected = <<~HTML
      <div class="mb-3 g-3">
        <label class="form-label col-form-label col-sm-2 required" for="user_email">Email</label>
        <div class="col-sm-10">
          <input aria-required="true" required="required" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @horizontal_builder.text_field(:email, wrapper_class: "mb-3 g-3")
    assert_equivalent_html expected, @horizontal_builder.text_field(:email, wrapper: { class: "mb-3 g-3" })
  end

  test "text fields are wrapped correctly when horizontal and multiple wrapper classes specified" do
    expected = <<~HTML
      <div class="bogus-2 row">
        <label class="form-label col-form-label col-sm-2 required" for="user_email">Email</label>
        <div class="col-sm-10">
          <input aria-required="true" required="required" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
        </div>
      </div>
    HTML
    assert_equivalent_html expected,
                           @horizontal_builder.text_field(:email, wrapper_class: "bogus-1", wrapper: { class: "bogus-2" })
  end

  test "text fields are wrapped correctly when horizontal and wrapper class specified" do
    expected = <<~HTML
      <div class="bogus-1 row">
        <label class="form-label col-form-label col-sm-2 required" for="user_email">Email</label>
        <div class="col-sm-10">
          <input aria-required="true" required="required" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @horizontal_builder.text_field(:email, wrapper_class: "bogus-1")
  end

  test "text fields are wrapped correctly when horizontal and multiple wrapper classes specified (reverse order)" do
    expected = <<~HTML
      <div class="bogus-2 row">
        <label class="form-label col-form-label col-sm-2 required" for="user_email">Email</label>
        <div class="col-sm-10">
          <input aria-required="true" required="required" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
        </div>
      </div>
    HTML
    assert_equivalent_html expected,
                           @horizontal_builder.text_field(:email, wrapper: { class: "bogus-2" }, wrapper_class: "bogus-1")
  end

  test "field 'id' attribute is used to specify label 'for' attribute" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label required" for="custom_id">Email</label>
        <input aria-required="true" required="required" class="form-control" id="custom_id" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.text_field(:email, id: :custom_id)
  end

  test "time fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="time" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.time_field(:misc)
  end

  test "url fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="url" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.url_field(:misc)
  end

  test "check_box fields are wrapped correctly" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[misc]" type="hidden" value="0"/>
        <input class="form-check-input" id="user_misc" name="user[misc]" type="checkbox" value="1"/>
        <label class="form-check-label" for="user_misc">Misc</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:misc)
  end

  test "switch-style check_box fields are wrapped correctly" do
    expected = <<~HTML
      <div class="form-check mb-3 form-switch">
        <input #{autocomplete_attr} name="user[misc]" type="hidden" value="0"/>
        <input class="form-check-input" id="user_misc" name="user[misc]" type="checkbox" value="1"/>
        <label class="form-check-label" for="user_misc">Misc</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:misc, switch: true)
  end

  test "week fields are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="week" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.week_field(:misc)
  end

  test "bootstrap_form_for helper works for associations" do
    @user.address = Address.new(street: "123 Main Street")

    output = bootstrap_form_for(@user) do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
        <div class="mb-3">
          <label class="form-label" for="user_address_attributes_street">Street</label>
          <input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "bootstrap_form_for helper works for serialized hash attributes" do
    @user.preferences = { "favorite_color" => "cerulean" }

    output = bootstrap_form_for(@user) do |f|
      f.fields_for :preferences do |builder|
        builder.text_field :favorite_color, value: @user.preferences["favorite_color"]
      end
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
        <div class="mb-3">
          <label class="form-label" for="user_preferences_favorite_color">Favorite color</label>
          <input class="form-control" id="user_preferences_favorite_color" name="user[preferences][favorite_color]" type="text" value="cerulean" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "fields_for correctly passes horizontal style from parent builder" do
    @user.address = Address.new(street: "123 Main Street")

    output = bootstrap_form_for(@user, layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10") do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
        <div class="mb-3 row">
          <label class="form-label col-form-label col-sm-2" for="user_address_attributes_street">Street</label>
          <div class="col-sm-10">
            <input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "fields_for correctly passes inline style from parent builder" do
    @user.address = Address.new(street: "123 Main Street")

    # NOTE: This test works with even if you use `fields_for_without_bootstrap`
    output = bootstrap_form_for(@user, layout: :inline) do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user row row-cols-auto g-3 align-items-center" id="new_user" method="post">
        #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
        <div class="col">
          <label class="form-label me-sm-2" for="user_address_attributes_street">Street</label>
          <input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "fields correctly uses options from parent builder" do
    @user.address = Address.new(street: "123 Main Street")

    bootstrap_form_with(model: @user,
                        control_col: "control-style",
                        inline_errors: false,
                        label_col: "label-style",
                        label_errors: true,
                        layout: :inline) do |f|
      f.fields :address do |af|
        af.text_field(:street)
        assert_equal "control-style", af.control_col
        assert_equal false, af.inline_errors
        assert_equal "label-style", af.label_col
        assert_equal true, af.label_errors
        assert_equal :inline, af.layout
      end
    end
  end

  test "fields_for_without_bootstrap does not use options from parent builder" do
    @user.address = Address.new(street: "123 Main Street")

    bootstrap_form_for(@user,
                       control_col: "control-style",
                       inline_errors: false,
                       label_col: "label-style",
                       label_errors: true,
                       layout: :inline) do |f|
      f.fields_for_without_bootstrap :address do |af|
        af.text_field(:street)
        assert_not_equal "control-style", af.control_col
        assert_not_equal false, af.inline_errors
        assert_not_equal "label-style", af.label_col
        assert_not_equal true, af.label_errors
        assert_not_equal :inline, af.layout
      end
    end
  end

  test "can have a floating label" do
    expected = <<~HTML
      <div class="mb-3 form-floating">
        <input aria-required="true" required="required" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" placeholder="Email" />
        <label class="form-label required" for="user_email">Email</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.text_field(:email, floating: true)
  end
end
