if ::Rails::VERSION::STRING >= '5.1'
  require 'test_helper'

  class BootstrapFormWithFieldsTest < ActionView::TestCase
    include BootstrapForm::Helper

    def setup
      setup_test_fixture
    end

    # Tests for field types that have explicit labels, and therefore are
    # potentially affected by the lack of default DOM ids from `form_with`.

    test "form_with text areas are wrapped correctly" do
      expected = %{<div class="form-group"><label class="form-control-label">Comments</label><textarea class="form-control" name="user[comments]">\nmy comment</textarea></div>}
      # puts "Rails: #{ActionView::Helpers::FormBuilder.new(:user, @user, self, {}).text_area(:comments)}"
      assert_equivalent_xml expected, @form_with_builder.text_area(:comments)
      expected = %{<div class="form-group"><label class="form-control-label" for="user_comments">Comments</label><textarea class="form-control" id="user_comments" name="user[comments]">\nmy comment</textarea></div>}
      # Doesn't the new Rails way mean everyone has to know how to generate Rails field IDs?
      assert_equivalent_xml expected, @form_with_builder.text_area(:comments, id: :user_comments)
    end

    test "form_with password fields are wrapped correctly" do
      expected = %{<div class="form-group"><label class="form-control-label">Password</label><input class="form-control" name="user[password]" type="password" /><span class="form-text text-muted">A good password should be at least six characters long</span></div>}
      assert_equivalent_xml expected, @form_with_builder.password_field(:password)
      expected = %{<div class="form-group"><label class="form-control-label" for="user_password">Password</label><input class="form-control" id="user_password" name="user[password]" type="password" /><span class="form-text text-muted">A good password should be at least six characters long</span></div>}
      assert_equivalent_xml expected, @form_with_builder.password_field(:password, id: :user_password)
    end

    test "form_with file fields are wrapped correctly" do
      expected = %{<div class="form-group"><label class="form-control-label">Misc</label><input name="user[misc]" type="file" /></div>}
      assert_equivalent_xml expected, @form_with_builder.file_field(:misc)
      expected = %{<div class="form-group"><label class="form-control-label" for="user_misc">Misc</label><input id="user_misc" name="user[misc]" type="file" /></div>}
      assert_equivalent_xml expected, @form_with_builder.file_field(:misc, id: :user_misc)
    end

    test "form_with text fields are wrapped correctly" do
      expected = %{<div class="form-group"><label class="form-control-label required">Email</label><input class="form-control" name="user[email]" type="text" value="steve@example.com" /></div>}
      assert_equivalent_xml expected, @form_with_builder.text_field(:email)
      expected = %{<div class="form-group"><label class="form-control-label required" for="user_email">Email</label><input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" /></div>}
      assert_equivalent_xml expected, @form_with_builder.text_field(:email, id: :user_email)
    end

    test "bootstrap_form_with helper works for associations" do
      @user.address = Address.new(street: '123 Main Street')

      output = bootstrap_form_with(model: @user, local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street)
        end
      end

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label class="form-control-label">Street</label>
            <input class="form-control" name="user[address_attributes][street]" type="text" value="123 Main Street" />
          </div>
        </form>
      HTML
      assert_equivalent_xml expected, output

      output = bootstrap_form_with(model: @user, local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street, id: :user_address_attributes_street)
        end
      end

      expected = %{<form accept-charset="UTF-8" action="/users" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="form-control-label" for="user_address_attributes_street">Street</label><input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" /></div></form>}
      assert_equivalent_xml expected, output
    end

    test "bootstrap_form_with helper works for serialized hash attributes" do
      @user.preferences = { favorite_color: "cerulean" }

      output = bootstrap_form_with(model: @user, local: true) do |f|
        f.fields :preferences do |builder|
          builder.text_field :favorite_color, value: @user.preferences[:favorite_color]
        end
      end

      expected = %{<form accept-charset="UTF-8" action="/users" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="form-control-label">Favorite color</label><input class="form-control" name="user[preferences][favorite_color]" type="text" value="cerulean" /></div></form>}
      assert_equivalent_xml expected, output

      output = bootstrap_form_with(model: @user, local: true) do |f|
        f.fields :preferences do |builder|
          builder.text_field :favorite_color, value: @user.preferences[:favorite_color], id: :user_preferences_favorite_color
        end
      end

      expected = %{<form accept-charset="UTF-8" action="/users" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="form-control-label" for="user_preferences_favorite_color">Favorite color</label><input class="form-control" id="user_preferences_favorite_color" name="user[preferences][favorite_color]" type="text" value="cerulean" /></div></form>}
      assert_equivalent_xml expected, output
    end

    test "form_with fields correctly passes horizontal style from parent builder" do
      @user.address = Address.new(street: '123 Main Street')

      output = bootstrap_form_with(model: @user, layout: :horizontal, label_col: 'col-sm-2', control_col: 'col-sm-10', local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street)
        end
      end

      expected = %{<form accept-charset="UTF-8" action="/users" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group row"><label class="form-control-label col-sm-2">Street</label><div class="col-sm-10"><input class="form-control" name="user[address_attributes][street]" type="text" value="123 Main Street" /></div></div></form>}
      assert_equivalent_xml expected, output

      output = bootstrap_form_with(model: @user, layout: :horizontal, label_col: 'col-sm-2', control_col: 'col-sm-10', local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street, id: :user_address_attributes_street)
        end
      end

      expected = %{<form accept-charset="UTF-8" action="/users" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group row"><label class="form-control-label col-sm-2" for="user_address_attributes_street">Street</label><div class="col-sm-10"><input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" /></div></div></form>}
      assert_equivalent_xml expected, output
    end

    test "form_with fields correctly passes inline style from parent builder" do
      @user.address = Address.new(street: '123 Main Street')

      output = bootstrap_form_with(model: @user, layout: :inline, local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street)
        end
      end

      expected = %{<form accept-charset="UTF-8" action="/users" class="form-inline" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="form-control-label">Street</label><input class="form-control" name="user[address_attributes][street]" type="text" value="123 Main Street" /></div></form>}
      assert_equivalent_xml expected, output

      output = bootstrap_form_with(model: @user, layout: :inline, local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street, id: :user_address_attributes_street)
        end
      end

      expected = %{<form accept-charset="UTF-8" action="/users" class="form-inline" method="post" role="form"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class="form-group"><label class="form-control-label" for="user_address_attributes_street">Street</label><input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" /></div></form>}
      assert_equivalent_xml expected, output
    end
  end
end
