require_relative "./test_helper"

class BootstrapFieldsTest < ActionView::TestCase
  include BootstrapForm::Helper

  setup :setup_test_fixture

  test "color fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="color" value="#000000" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.color_field(:misc)
  end

  test "date fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="date" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.date_field(:misc)
  end

  test "date time fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="datetime" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.datetime_field(:misc)
  end

  test "date time local fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="datetime-local" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.datetime_local_field(:misc)
  end

  test "email fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="email" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.email_field(:misc)
  end

  test "file fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="custom-file">
          <input class="custom-file-input" id="user_misc" name="user[misc]" type="file" />
          <label class="custom-file-label" for="user_misc">Choose file</label>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.file_field(:misc)
  end

  test "file field placeholder can be customized" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="custom-file">
          <input class="custom-file-input" id="user_misc" name="user[misc]" type="file" />
          <label class="custom-file-label" for="user_misc">Pick a file</label>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.file_field(:misc, placeholder: "Pick a file")
  end

  if ::Rails::VERSION::STRING > '5.1'
    test "file field placeholder has appropriate `for` attribute when used in form_with" do
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="custom-id">Misc</label>
          <div class="custom-file">
            <input class="custom-file-input" id="custom-id" name="user[misc]" type="file" />
            <label class="custom-file-label" for="custom-id">Choose file</label>
          </div>
        </div>
      HTML
      assert_equivalent_xml expected, form_with_builder.file_field(:misc, id: "custom-id")
    end
  end

  test "file fields are wrapped correctly with error" do
    @user.errors.add(:misc, "error for test")
    expected = <<-HTML.strip_heredoc
    <form accept-charset="UTF-8" action="/users" class="new_user" enctype="multipart/form-data" id="new_user" method="post" role="form">
      <input name="utf8" type="hidden" value="&#x2713;"/>
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="custom-file">
          <input class="custom-file-input is-invalid" id="user_misc" name="user[misc]" type="file" />
          <label class="custom-file-label" for="user_misc">Choose file</label>
          <div class="invalid-feedback">error for test</div>
        </div>
      </div>
    </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| f.file_field(:misc) }
  end

  test "hidden fields are supported" do
    expected = %{<input id="user_misc" name="user[misc]" type="hidden" />}
    assert_equivalent_xml expected, @builder.hidden_field(:misc)
  end

  test "month local fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="month" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.month_field(:misc)
  end

  test "number fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="number" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.number_field(:misc)
  end

  test "password fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_password">Password</label>
        <input class="form-control" id="user_password" name="user[password]" type="password" />
        <small class="form-text text-muted">A good password should be at least six characters long</small>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.password_field(:password)
  end

  test "phone/telephone fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="tel" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.phone_field(:misc)
    assert_equivalent_xml expected, @builder.telephone_field(:misc)
  end

  test "range fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="range" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.range_field(:misc)
  end

  test "search fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="search" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.search_field(:misc)
  end

  test "text areas are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_comments">Comments</label>
        <textarea class="form-control" id="user_comments" name="user[comments]">\nmy comment</textarea>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_area(:comments)
  end

  if ::Rails::VERSION::STRING > '5.1' && ::Rails::VERSION::STRING < '5.2'
    test "text areas are wrapped correctly form_with Rails 5.1" do
      expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_comments">Comments</label>
        <textarea class="form-control" name="user[comments]">\nmy comment</textarea>
      </div>
      HTML
      assert_equivalent_xml expected, form_with_builder.text_area(:comments)
    end
  end

  if ::Rails::VERSION::STRING > '5.2'
    test "text areas are wrapped correctly form_with Rails 5.2+" do
      expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_comments">Comments</label>
        <textarea class="form-control" id="user_comments" name="user[comments]">\nmy comment</textarea>
      </div>
      HTML
      assert_equivalent_xml expected, form_with_builder.text_area(:comments)
    end
  end

  test "text fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="user_email">Email</label>
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email)
  end

  test "text fields are wrapped correctly when horizontal and form-row given" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group form-row">
        <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
        <div class="col-sm-10">
          <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, @horizontal_builder.text_field(:email, wrapper_class: "form-row")
    assert_equivalent_xml expected, @horizontal_builder.text_field(:email, wrapper: { class: "form-row" })
  end

  test "field 'id' attribute is used to specify label 'for' attribute" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="custom_id">Email</label>
        <input class="form-control" id="custom_id" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, id: :custom_id)
  end

  test "time fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="time" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.time_field(:misc)
  end

  test "url fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="url" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.url_field(:misc)
  end

  test "week fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="week" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.week_field(:misc)
  end

  test "bootstrap_form_for helper works for associations" do
    @user.address = Address.new(street: '123 Main Street')

    output = bootstrap_form_for(@user) do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label for="user_address_attributes_street">Street</label>
          <input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" />
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  test "bootstrap_form_for helper works for serialized hash attributes" do
    @user.preferences = { favorite_color: "cerulean" }

    output = bootstrap_form_for(@user) do |f|
      f.fields_for :preferences do |builder|
        builder.text_field :favorite_color, value: @user.preferences[:favorite_color]
      end
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label for="user_preferences_favorite_color">Favorite color</label>
          <input class="form-control" id="user_preferences_favorite_color" name="user[preferences][favorite_color]" type="text" value="cerulean" />
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  test "fields_for correctly passes horizontal style from parent builder" do
    @user.address = Address.new(street: '123 Main Street')

    output = bootstrap_form_for(@user, layout: :horizontal, label_col: 'col-sm-2', control_col: 'col-sm-10') do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group row">
          <label class="col-form-label col-sm-2" for="user_address_attributes_street">Street</label>
          <div class="col-sm-10">
            <input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  test "fields_for correctly passes inline style from parent builder" do
    @user.address = Address.new(street: '123 Main Street')

    # NOTE: This test works with even if you use `fields_for_without_bootstrap`
    output = bootstrap_form_for(@user, layout: :inline) do |f|
      f.fields_for :address do |af|
        af.text_field(:street)
      end
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="form-inline" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="mr-sm-2" for="user_address_attributes_street">Street</label>
          <input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" />
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  if ::Rails::VERSION::STRING >= '5.1'
    test "fields correctly uses options from parent builder" do
      @user.address = Address.new(street: '123 Main Street')

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
  end

  test "fields_for_without_bootstrap does not use options from parent builder" do
    @user.address = Address.new(street: '123 Main Street')

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
end
