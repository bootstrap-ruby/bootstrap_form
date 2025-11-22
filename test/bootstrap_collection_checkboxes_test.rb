# frozen_string_literal: true

require_relative "test_helper"

class BootstrapCollectionCheckboxesTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup do
    setup_test_fixture
    Rails.application.config.bootstrap_form.fieldset_around_collections = true
  end

  teardown do
    Rails.application.config.bootstrap_form.fieldset_around_collections = false
  end

  test "collection_check_boxes renders the form_group correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>This is a checkbox collection</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     label: "This is a checkbox collection", help: "With a help!")
  end

  if Rails::VERSION::MAJOR >= 8
    test "collection_checkboxes renders the form_group correctly" do
      collection = [Address.new(id: 1, street: "Foobar")]
      expected = <<~HTML
        <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
        <fieldset class="mb-3">
          <legend>This is a checkbox collection</legend>
          <div class="form-check">
            <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_misc_1">Foobar</label>
          </div>
          <small class="form-text text-muted">With a help!</small>
        </fieldset>
      HTML

      assert_equivalent_html expected, @builder.collection_checkboxes(:misc, collection, :id, :street,
                                                                      label: "This is a checkbox collection", help: "With a help!")
    end
  end

  test "collection_check_boxes renders multiple checkboxes correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street)
  end

  test "collection_check_boxes renders multiple checkboxes contains unicode characters in IDs correctly" do
    struct = Struct.new(:id, :name)
    collection = [struct.new(1, "Foo"), struct.new("二", "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_二" name="user[misc][]" type="checkbox" value="二" />
          <label class="form-check-label" for="user_misc_二">Bar</label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :name)
  end

  test "collection_check_boxes renders inline checkboxes correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend class="form-check form-check-inline ps-0">Misc</legend>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street, inline: true)
  end

  test "collection_check_boxes renders with checked option correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: 1)
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: collection.first)
  end

  test "collection_check_boxes renders with multiple checked options correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: [1, 2])
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: collection)
  end

  test "collection_check_boxes sanitizes values when generating label `for`" do
    collection = [Address.new(id: 1, street: "Foo St")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_foo_st" name="user[misc][]" type="checkbox" value="Foo St" />
          <label class="form-check-label" for="user_misc_foo_st">
            Foo St
          </label>
        </div>
      </fieldset>
    HTML
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :street, :street)
  end

  test "collection_check_boxes renders multiple checkboxes with labels defined by Proc :text_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            ooF
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            raB
          </label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, proc { |a| a.street.reverse })
  end

  test "collection_check_boxes renders multiple checkboxes with values defined by Proc :value_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </fieldset>
    HTML
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" },
                                                                     :street)
  end

  test "collection_check_boxes renders multiple checkboxes with labels defined by lambda :text_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            ooF
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            raB
          </label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, ->(a) { a.street.reverse })
  end

  test "collection_check_boxes renders multiple checkboxes with values defined by lambda :value_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" },
                                                                     :street)
  end

  test "collection_check_boxes renders with checked option correctly with Proc :value_method" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" },
                                                                     :street, checked: "address_1")
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" },
                                                                     :street, checked: collection.first)
  end

  test "collection_check_boxes renders with multiple checked options correctly with lambda :value_method" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" },
                                                                     :street, checked: %w[address_1 address_2])
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" },
                                                                     :street, checked: collection)
  end

  test "collection_check_boxes renders with include_hidden options correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">Bar</label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street, include_hidden: false)
  end

  test "collection_check_boxes renders error after last check box" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    @user.errors.add(:misc, "a box must be checked")

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
        <fieldset class="mb-3">
          <legend>Misc</legend>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_misc_1">Foo</label>
          </div>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
            <label class="form-check-label" for="user_misc_2">Bar</label>
            <div class="invalid-feedback">a box must be checked</div>
          </div>
        </fieldset>
      </form>
    HTML

    actual = bootstrap_form_for(@user) do |f|
      f.collection_check_boxes(:misc, collection, :id, :street)
    end

    assert_equivalent_html expected, actual
  end

  test "collection_check_boxes renders data attributes" do
    collection = [
      ["1", "Foo", { "data-city": "east" }],
      ["2", "Bar", { "data-city": "west" }]
    ]
    expected = <<~HTML
      <fieldset class="mb-3">
        <legend>Misc</legend>
        <div class="form-check">
          <input class="form-check-input" data-city="east" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" data-city="west" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">Bar</label>
        </div>
      </fieldset>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :first, :second, include_hidden: false)
  end

  test "collection_check_boxes renders multiple check boxes with error correctly" do
    @user.errors.add(:misc, "error for test")
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
        <fieldset class="mb-3">
          <legend>Misc</legend>
          <div class="form-check">
            <input checked="checked" class="form-check-input is-invalid" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_misc_1"> Foo</label>
          </div>
          <div class="form-check">
            <input checked="checked" class="form-check-input is-invalid" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
            <label class="form-check-label" for="user_misc_2"> Bar</label>
            <div class="invalid-feedback">error for test</div>
          </div>
        </fieldset>
      </form>
    HTML

    actual = bootstrap_form_for(@user) do |f|
      f.collection_check_boxes(:misc, collection, :id, :street, checked: collection)
    end
    assert_equivalent_html expected, actual
  end
end

class BootstrapLegacyCollectionCheckboxesTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  test "collection_check_boxes renders the form_group correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">This is a checkbox collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     label: "This is a checkbox collection", help: "With a help!")
  end

  if Rails::VERSION::MAJOR >= 8
    test "collection_checkboxes renders the form_group correctly" do
      collection = [Address.new(id: 1, street: "Foobar")]
      expected = <<~HTML
        <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
        <div class="mb-3">
          <label class="form-label" for="user_misc">This is a checkbox collection</label>
          <div class="form-check">
            <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_misc_1">Foobar</label>
          </div>
          <small class="form-text text-muted">With a help!</small>
        </div>
      HTML

      assert_equivalent_html expected, @builder.collection_checkboxes(:misc, collection, :id, :street,
                                                                      label: "This is a checkbox collection", help: "With a help!")
    end
  end

  test "collection_check_boxes renders multiple checkboxes correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street)
  end

  test "collection_check_boxes renders multiple checkboxes contains unicode characters in IDs correctly" do
    struct = Struct.new(:id, :name)
    collection = [struct.new(1, "Foo"), struct.new("二", "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_二" name="user[misc][]" type="checkbox" value="二" />
          <label class="form-check-label" for="user_misc_二">Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :name)
  end

  test "collection_check_boxes renders inline checkboxes correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-check form-check-inline ps-0" for="user_misc">Misc</label>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street, inline: true)
  end

  test "collection_check_boxes renders with checked option correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: 1)
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: collection.first)
  end

  test "collection_check_boxes renders with multiple checked options correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: [1, 2])
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: collection)
  end

  test "collection_check_boxes sanitizes values when generating label `for`" do
    collection = [Address.new(id: 1, street: "Foo St")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_foo_st" name="user[misc][]" type="checkbox" value="Foo St" />
          <label class="form-check-label" for="user_misc_foo_st">
            Foo St
          </label>
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :street, :street)
  end

  test "collection_check_boxes renders multiple checkboxes with labels defined by Proc :text_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            ooF
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            raB
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, proc { |a| a.street.reverse })
  end

  test "collection_check_boxes renders multiple checkboxes with values defined by Proc :value_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" },
                                                                     :street)
  end

  test "collection_check_boxes renders multiple checkboxes with labels defined by lambda :text_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            ooF
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            raB
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, ->(a) { a.street.reverse })
  end

  test "collection_check_boxes renders multiple checkboxes with values defined by lambda :value_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" },
                                                                     :street)
  end

  test "collection_check_boxes renders with checked option correctly with Proc :value_method" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" },
                                                                     :street, checked: "address_1")
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" },
                                                                     :street, checked: collection.first)
  end

  test "collection_check_boxes renders with multiple checked options correctly with lambda :value_method" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" },
                                                                     :street, checked: %w[address_1 address_2])
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" },
                                                                     :street, checked: collection)
  end

  test "collection_check_boxes renders with include_hidden options correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street, include_hidden: false)
  end

  test "collection_check_boxes renders error after last check box" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    @user.errors.add(:misc, "a box must be checked")

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_misc_1">Foo</label>
          </div>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
            <label class="form-check-label" for="user_misc_2">Bar</label>
            <div class="invalid-feedback">a box must be checked</div>
          </div>
        </div>
      </form>
    HTML

    actual = bootstrap_form_for(@user) do |f|
      f.collection_check_boxes(:misc, collection, :id, :street)
    end

    assert_equivalent_html expected, actual
  end

  test "collection_check_boxes renders data attributes" do
    collection = [
      ["1", "Foo", { "data-city": "east" }],
      ["2", "Bar", { "data-city": "west" }]
    ]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" data-city="east" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" data-city="west" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :first, :second, include_hidden: false)
  end

  test "collection_check_boxes renders multiple check boxes with error correctly" do
    @user.errors.add(:misc, "error for test")
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          <input #{autocomplete_attr_55336} id="user_misc" name="user[misc][]" type="hidden" value="" />
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="form-check">
            <input checked="checked" class="form-check-input is-invalid" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_misc_1"> Foo</label>
          </div>
          <div class="form-check">
            <input checked="checked" class="form-check-input is-invalid" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
            <label class="form-check-label" for="user_misc_2"> Bar</label>
            <div class="invalid-feedback">error for test</div>
          </div>
        </div>
      </form>
    HTML

    actual = bootstrap_form_for(@user) do |f|
      f.collection_check_boxes(:misc, collection, :id, :street, checked: collection)
    end
    assert_equivalent_html expected, actual
  end
end
