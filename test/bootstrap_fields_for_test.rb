# frozen_string_literal: true

require_relative "test_helper"

class BootstrapFieldsForTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  test "bootstrap_fields_for helper works for associations" do
    @user.address = Address.new(street: "123 Main Street")

    output = bootstrap_form_for(@user) do |_f|
      bootstrap_fields_for @user.address do |af|
        af.text_field(:street)
      end
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label" for="address_street">Street</label>
          <input class="form-control" id="address_street" name="address[street]" type="text" value="123 Main Street" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "bootstrap_fields_for helper works with boolean options" do
    @user.address = Address.new
    @user.valid?

    output = bootstrap_form_for(@user, inline_errors: true) do |_f|
      bootstrap_fields_for :address, @user.address, inline_errors: false do |af|
        af.text_field(:city)
      end
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label required" for="address_city">City</label>
          <input class="form-control is-invalid" id="address_city" aria-describedby="address_city_feedback" name="address[city]" type="text" required="required" />
          <!-- No `<div class="invalid-feedback">can't be blank</div>` -->
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "bootstrap_fields_for helper works for serialized hash attributes" do
    @user.preferences = { "favorite_color" => "cerulean" }

    output = bootstrap_form_for(@user) do |_f|
      bootstrap_fields_for :preferences do |builder|
        builder.text_field :favorite_color, value: @user.preferences["favorite_color"]
      end
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label" for="preferences_favorite_color">Favorite color</label>
          <input class="form-control" id="preferences_favorite_color" name="preferences[favorite_color]" type="text" value="cerulean" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "bootstrap_fields helper works for associations" do
    @user.address = Address.new(street: "123 Main Street")

    output = bootstrap_form_for(@user) do |_f|
      bootstrap_fields @user.address do |af|
        af.text_field(:street)
      end
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label" for="address_street">Street</label>
          <input class="form-control" id="address_street" name="address[street]" type="text" value="123 Main Street" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end

  test "bootstrap_fields helper works for serialized hash attributes" do
    @user.preferences = { "favorite_color" => "cerulean" }

    output = bootstrap_form_for(@user) do |_f|
      bootstrap_fields :preferences do |builder|
        builder.text_field :favorite_color, value: @user.preferences["favorite_color"]
      end
    end

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label" for="preferences_favorite_color">Favorite color</label>
          <input class="form-control" id="preferences_favorite_color" name="preferences[favorite_color]" type="text" value="cerulean" />
        </div>
      </form>
    HTML
    assert_equivalent_html expected, output
  end
end
