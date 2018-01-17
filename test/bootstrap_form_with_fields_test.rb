# The following allows us to test this file individually with:
# 'bundle exec rake test TEST=test/bootstrap_form_with_fields_test.rb'
require 'rails'

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
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="user_comments">Comments</label>
          <textarea class="form-control" id="user_comments" name="user[comments]">\nmy comment</textarea>
        </div>
      HTML
      # puts "Rails: #{ActionView::Helpers::FormBuilder.new(:user, @user, self, {}).text_area(:comments)}"
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), @form_with_builder.text_area(:comments)

      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="TEST_ID">Comments</label>
          <textarea class="form-control" id="TEST_ID" name="user[comments]">\nmy comment</textarea>
        </div>
      HTML
      assert_equivalent_xml expected, @form_with_builder.text_area(:comments, id: :TEST_ID)
    end

    test "form_with password fields are wrapped correctly" do
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="user_password">Password</label>
          <input class="form-control" id="user_password" name="user[password]" type="password" />
          <small class="form-text text-muted">A good password should be at least six characters long</small>
        </div>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), @form_with_builder.password_field(:password)
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="TEST_ID">Password</label>
          <input class="form-control" id="TEST_ID" name="user[password]" type="password" />
          <span class="form-text text-muted">A good password should be at least six characters long</span>
        </div>
      HTML
      assert_equivalent_xml expected, @form_with_builder.password_field(:password, id: :TEST_ID)
    end

    test "form_with file fields are wrapped correctly" do
      expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input id="user_misc" name="user[misc]" type="file" />
      </div>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), @form_with_builder.file_field(:misc)
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="TEST_ID">Misc</label>
          <input id="TEST_ID" name="user[misc]" type="file" />
        </div>
      HTML
      assert_equivalent_xml expected, @form_with_builder.file_field(:misc, id: :TEST_ID)
    end

    test "form_with text fields are wrapped correctly" do
      expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="user_email">Email</label>
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), @form_with_builder.text_field(:email)
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label class="required" for="TEST_ID">Email</label>
          <input class="form-control" id="TEST_ID" name="user[email]" type="text" value="steve@example.com" />
        </div>
      HTML
      assert_equivalent_xml expected, @form_with_builder.text_field(:email, id: :TEST_ID)
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
          <label for="user_address_attributes_street">Street</label>
          <input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" />
        </div>
      </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), output

      output = bootstrap_form_with(model: @user, local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street, id: :TEST_ID)
        end
      end

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label for="TEST_ID">Street</label>
            <input class="form-control" id="TEST_ID" name="user[address_attributes][street]" type="text" value="123 Main Street" />
          </div>
        </form>
      HTML
      assert_equivalent_xml expected, output
    end

    test "bootstrap_form_with helper works for serialized hash attributes" do
      @user.preferences = { favorite_color: "cerulean" }

      output = bootstrap_form_with(model: @user, local: true) do |f|
        f.fields :preferences do |builder|
          builder.text_field :favorite_color, value: @user.preferences[:favorite_color]
        end
      end

      expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label for="user_preferences_favorite_color">Favorite color</label>
          <input class="form-control" id="user_preferences_favorite_color" name="user[preferences][favorite_color]" type="text" value="cerulean" />
        </div>
      </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), output

      output = bootstrap_form_with(model: @user, local: true) do |f|
        f.fields :preferences do |builder|
          builder.text_field :favorite_color, value: @user.preferences[:favorite_color], id: :TEST_ID
        end
      end

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" method="post" role="form">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label for="TEST_ID">Favorite color</label>
            <input class="form-control" id="TEST_ID" name="user[preferences][favorite_color]" type="text" value="cerulean" />
          </div>
        </form>
      HTML
      assert_equivalent_xml expected, output
    end

    test "form_with fields correctly passes horizontal style from parent builder" do
      @user.address = Address.new(street: '123 Main Street')

      output = bootstrap_form_with(model: @user, layout: :horizontal, label_col: 'col-sm-2', control_col: 'col-sm-10', local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street)
        end
      end

      expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group row">
          <label class="col-sm-2" for="user_address_attributes_street">Street</label>
          <div class="col-sm-10">
            <input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" />
          </div>
        </div>
      </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), output

      output = bootstrap_form_with(model: @user, layout: :horizontal, label_col: 'col-sm-2', control_col: 'col-sm-10', local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street, id: :TEST_ID)
        end
      end

      expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group row">
          <label class="col-sm-2" for="TEST_ID">Street</label>
          <div class="col-sm-10">
            <input class="form-control" id="TEST_ID" name="user[address_attributes][street]" type="text" value="123 Main Street" />
          </div>
        </div>
      </form>
      HTML
      assert_equivalent_xml expected, output
    end

    test "form_with fields correctly passes inline style from parent builder" do
      @user.address = Address.new(street: '123 Main Street')

      output = bootstrap_form_with(model: @user, layout: :inline, local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street)
        end
      end

      expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="form-inline" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label for="user_address_attributes_street">Street</label>
          <input class="form-control" id="user_address_attributes_street" name="user[address_attributes][street]" type="text" value="123 Main Street" />
        </div>
      </form>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), output

      output = bootstrap_form_with(model: @user, layout: :inline, local: true) do |f|
        f.fields :address do |af|
          af.text_field(:street, id: :TEST_ID)
        end
      end

      expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="form-inline" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label for="TEST_ID">Street</label>
          <input class="form-control" id="TEST_ID" name="user[address_attributes][street]" type="text" value="123 Main Street" />
        </div>
      </form>
      HTML
      assert_equivalent_xml expected, output
    end
  end
end
