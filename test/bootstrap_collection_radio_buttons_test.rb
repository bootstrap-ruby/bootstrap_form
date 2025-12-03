# frozen_string_literal: true

require_relative "test_helper"

class BootstrapCollectionRadioButtonsTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup do
    setup_test_fixture
    Rails.application.config.bootstrap_form.group_around_collections = true
  end

  teardown do
    Rails.application.config.bootstrap_form.group_around_collections = false
  end

  test "collection_radio_buttons renders the form_group correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div id="user_misc" class="form-label">This is a radio button collection</div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foobar
          </label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected,
                           @builder.collection_radio_buttons(:misc, collection, :id, :street,
                                                             label: "This is a radio button collection", help: "With a help!")
  end

  test "collection_radio_buttons renders multiple radios correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div id="user_misc" class="form-label">Misc</div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, :id, :street)
  end

  test "collection_radio_buttons renders multiple radios with error correctly" do
    @user.errors.add(:misc, "error for test")
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div role="group" aria-labelledby="user_misc" class="mb-3">
          <div id="user_misc" class="form-label">Misc</div>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1"> Foo</label>
          </div>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2"> Bar</label>
            <div class="invalid-feedback">error for test</div>
          </div>
        </div>
      </form>
    HTML

    actual = bootstrap_form_for(@user) do |f|
      f.collection_radio_buttons(:misc, collection, :id, :street)
    end
    assert_equivalent_html expected, actual
  end

  test "collection_radio_buttons renders inline radios correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div class="form-check form-check-inline ps-0" id="user_misc">Misc</div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, inline: true)
  end

  test "collection_radio_buttons renders with checked option correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div id="user_misc" class="form-label">Misc</div>
        <div class="form-check">
          <input class="form-check-input" checked="checked" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, checked: 1)
  end

  test "collection_radio_buttons renders label defined by Proc correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div id="user_misc" class="form-label">This is a radio button collection</div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> rabooF</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected,
                           @builder.collection_radio_buttons(:misc, collection, :id, proc { |a| a.street.reverse },
                                                             label: "This is a radio button collection", help: "With a help!")
  end

  test "collection_radio_buttons renders value defined by Proc correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div id="user_misc" class="form-label">This is a radio button collection</div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected,
                           @builder.collection_radio_buttons(:misc, collection, proc { |a| "address_#{a.id}" },
                                                             :street, label: "This is a radio button collection",
                                                                      help: "With a help!")
  end

  test "collection_radio_buttons renders multiple radios with label defined by Proc correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div id="user_misc" class="form-label">Misc</div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> ooF</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> raB</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, :id, proc { |a| a.street.reverse })
  end

  test "collection_radio_buttons renders multiple radios with value defined by Proc correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div id="user_misc" class="form-label">Misc</div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc]" type="radio" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, proc { |a| "address_#{a.id}" }, :street)
  end

  test "collection_radio_buttons renders label defined by lambda correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div id="user_misc" class="form-label">This is a radio button collection</div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> rabooF</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected,
                           @builder.collection_radio_buttons(:misc, collection, :id, ->(a) { a.street.reverse },
                                                             label: "This is a radio button collection", help: "With a help!")
  end

  test "collection_radio_buttons renders value defined by lambda correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div id="user_misc" class="form-label">This is a radio button collection</div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected,
                           @builder.collection_radio_buttons(:misc, collection, ->(a) { "address_#{a.id}" },
                                                             :street, label: "This is a radio button collection",
                                                                      help: "With a help!")
  end

  test "collection_radio_buttons renders multiple radios with label defined by lambda correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div id="user_misc" class="form-label">Misc</div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> ooF</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> raB</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, :id, ->(a) { a.street.reverse })
  end

  test "collection_radio_buttons renders multiple radios with value defined by lambda correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div role="group" aria-labelledby="user_misc" class="mb-3">
        <div id="user_misc" class="form-label">Misc</div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc]" type="radio" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, ->(a) { "address_#{a.id}" }, :street)
  end
end

class BootstrapCLegacyollectionRadioButtonsTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup do
    setup_test_fixture
    Rails.application.config.bootstrap_form.group_around_collections = false
  end

  teardown do
    Rails.application.config.bootstrap_form.group_around_collections = true
  end

  test "collection_radio_buttons renders the form_group correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">This is a radio button collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foobar
          </label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected,
                           @builder.collection_radio_buttons(:misc, collection, :id, :street,
                                                             label: "This is a radio button collection", help: "With a help!")
  end

  test "collection_radio_buttons renders multiple radios correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, :id, :street)
  end

  test "collection_radio_buttons renders multiple radios with error correctly" do
    @user.errors.add(:misc, "error for test")
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1"> Foo</label>
          </div>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2"> Bar</label>
            <div class="invalid-feedback">error for test</div>
          </div>
        </div>
      </form>
    HTML

    actual = bootstrap_form_for(@user) do |f|
      f.collection_radio_buttons(:misc, collection, :id, :street)
    end
    assert_equivalent_html expected, actual
  end

  test "collection_radio_buttons renders inline radios correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-check form-check-inline ps-0" for="user_misc">Misc</label>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, inline: true)
  end

  test "collection_radio_buttons renders with checked option correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" checked="checked" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, checked: 1)
  end

  test "collection_radio_buttons renders label defined by Proc correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">This is a radio button collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> rabooF</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected,
                           @builder.collection_radio_buttons(:misc, collection, :id, proc { |a| a.street.reverse },
                                                             label: "This is a radio button collection", help: "With a help!")
  end

  test "collection_radio_buttons renders value defined by Proc correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">This is a radio button collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected,
                           @builder.collection_radio_buttons(:misc, collection, proc { |a| "address_#{a.id}" },
                                                             :street, label: "This is a radio button collection",
                                                                      help: "With a help!")
  end

  test "collection_radio_buttons renders multiple radios with label defined by Proc correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> ooF</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> raB</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, :id, proc { |a| a.street.reverse })
  end

  test "collection_radio_buttons renders multiple radios with value defined by Proc correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc]" type="radio" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, proc { |a| "address_#{a.id}" }, :street)
  end

  test "collection_radio_buttons renders label defined by lambda correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">This is a radio button collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> rabooF</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected,
                           @builder.collection_radio_buttons(:misc, collection, :id, ->(a) { a.street.reverse },
                                                             label: "This is a radio button collection", help: "With a help!")
  end

  test "collection_radio_buttons renders value defined by lambda correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">This is a radio button collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected,
                           @builder.collection_radio_buttons(:misc, collection, ->(a) { "address_#{a.id}" },
                                                             :street, label: "This is a radio button collection",
                                                                      help: "With a help!")
  end

  test "collection_radio_buttons renders multiple radios with label defined by lambda correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> ooF</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> raB</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, :id, ->(a) { a.street.reverse })
  end

  test "collection_radio_buttons renders multiple radios with value defined by lambda correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc]" type="radio" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_radio_buttons(:misc, collection, ->(a) { "address_#{a.id}" }, :street)
  end
end
