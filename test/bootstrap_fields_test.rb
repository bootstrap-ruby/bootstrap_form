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
    # assert_equivalent_xml expected, @builder.color_field(:misc)
    assert_with_builder expected, :color_field, :misc
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
        <input class="form-control-file" id="user_misc" name="user[misc]" type="file" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.file_field(:misc)
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

  test "text fields are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="user_email">Email</label>
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email)
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

    ## TODO: DRY up the tests for the _with version
    if Gem::Version.new(::Rails::VERSION::STRING).release >= Gem::Version.new('5.1.0')
      output = bootstrap_form_with(model: @user, local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street)
        end
      end
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected.gsub(/ class="new_user" id="new_user"/, "")),
                            output
    end
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

    ## TODO: DRY up the tests for the _with version
    if Gem::Version.new(::Rails::VERSION::STRING).release >= Gem::Version.new('5.1.0')
      output = bootstrap_form_with(model: @user, layout: :horizontal, label_col: 'col-sm-2', control_col: 'col-sm-10', local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street)
        end
      end
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected.gsub(/ class="new_user" id="new_user"/, "")),
                            output
    end
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
          <label for="user_address_attributes_street">Street</label>
          <input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" />
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output

    ## TODO: DRY up the tests for the _with version
    if Gem::Version.new(::Rails::VERSION::STRING).release >= Gem::Version.new('5.1.0')
      output = bootstrap_form_with(model: @user, layout: :inline, local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street)
        end
      end
      # FIXME: Why doesn't this one generate `class="new_user"`?
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected.gsub(/ id="new_user"/, "")),
                            output
    end
  end
end
