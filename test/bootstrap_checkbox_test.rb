require_relative "./test_helper"

class BootstrapCheckboxTest < ActionView::TestCase
  include BootstrapForm::Helper

  setup :setup_test_fixture

  test "check_box is wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, label: 'I agree to the terms')
  end

  test "check_box empty label" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">&#8203;</label>
      </div>
    HTML
    # &#8203; is a zero-width space.
    assert_equivalent_xml expected, @builder.check_box(:terms, label: "&#8203;".html_safe)
  end

  test "disabled check_box has proper wrapper classes" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input name="user[terms]" type="hidden" value="0" disabled="disabled" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" disabled="disabled" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, label: 'I agree to the terms', disabled: true)
  end

  test "check_box label allows html" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the <a href="#">terms</a>
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, label: %{I agree to the <a href="#">terms</a>}.html_safe)
  end

  test "check_box accepts a block to define the label" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms) { "I agree to the terms" }
  end

  test "check_box accepts a custom label class" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label btn" for="user_terms">
          Terms
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, label_class: 'btn')
  end

  test "check_box 'id' attribute is used to specify label 'for' attribute" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="custom_id" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="custom_id">
          Terms
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, id: 'custom_id')
  end

  test "check_box responds to checked_value and unchecked_value arguments" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input name="user[terms]" type="hidden" value="no" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="yes" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, {label: 'I agree to the terms'}, 'yes', 'no')
  end

  test "inline checkboxes" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check form-check-inline">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, label: 'I agree to the terms', inline: true)
  end

  test "inline checkboxes from form layout" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="form-inline" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-check form-check-inline">
          <input name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">
            I agree to the terms
          </label>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user, layout: :inline) do |f|
      f.check_box(:terms, label: 'I agree to the terms')
    end
    assert_equivalent_xml expected, actual
  end

  test "disabled inline check_box" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check form-check-inline">
        <input name="user[terms]" type="hidden" value="0" disabled="disabled" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" disabled="disabled" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, label: 'I agree to the terms', inline: true, disabled: true)
  end

  test "inline checkboxes with custom label class" do
    expected = <<-HTML.strip_heredoc
    <div class="form-check form-check-inline">
      <input name="user[terms]" type="hidden" value="0" />
      <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
      <label class="form-check-label btn" for="user_terms">
        Terms
      </label>
    </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, inline: true, label_class: 'btn')
  end

  test 'collection_check_boxes renders the form_group correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">This is a checkbox collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, :id, :street, label: 'This is a checkbox collection', help: 'With a help!')
  end

  test 'collection_check_boxes renders multiple checkboxes correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, :id, :street)
  end

  test 'collection_check_boxes renders multiple checkboxes contains unicode characters in IDs correctly' do
    struct = Struct.new(:id, :name)
    collection = [struct.new(1, 'Foo'), struct.new('二', 'Bar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_二" name="user[misc][]" type="checkbox" value="二" />
          <label class="form-check-label" for="user_misc_二">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, :id, :name)
  end

  test 'collection_check_boxes renders inline checkboxes correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, :id, :street, inline: true)
  end

  test 'collection_check_boxes renders with checked option correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, :id, :street, checked: 1)
    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, :id, :street, checked: collection.first)
  end

  test 'collection_check_boxes renders with multiple checked options correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, :id, :street, checked: [1, 2])
    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, :id, :street, checked: collection)
  end

  test 'collection_check_boxes sanitizes values when generating label `for`' do
    collection = [Address.new(id: 1, street: 'Foo St')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_foo_st" name="user[misc][]" type="checkbox" value="Foo St" />
          <label class="form-check-label" for="user_misc_foo_st">
            Foo St
          </label>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, :street, :street)
  end

  test 'collection_check_boxes renders multiple checkboxes with labels defined by Proc :text_method correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, :id, Proc.new { |a| a.street.reverse })
  end

  test 'collection_check_boxes renders multiple checkboxes with values defined by Proc :value_method correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
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
    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, Proc.new { |a| "address_#{a.id}" }, :street)
  end

  test 'collection_check_boxes renders multiple checkboxes with labels defined by lambda :text_method correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, :id, lambda { |a| a.street.reverse })
  end

  test 'collection_check_boxes renders multiple checkboxes with values defined by lambda :value_method correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, lambda { |a| "address_#{a.id}" }, :street)
  end

  test 'collection_check_boxes renders with checked option correctly with Proc :value_method' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, Proc.new { |a| "address_#{a.id}" }, :street, checked: "address_1")
    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, Proc.new { |a| "address_#{a.id}" }, :street, checked: collection.first)
  end

  test 'collection_check_boxes renders with multiple checked options correctly with lambda :value_method' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, lambda { |a| "address_#{a.id}" }, :street, checked: ["address_1", "address_2"])
    assert_equivalent_xml expected, @builder.collection_check_boxes(:misc, collection, lambda { |a| "address_#{a.id}" }, :street, checked: collection)
  end

  test "check_box is wrapped correctly with custom option set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-checkbox">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="custom-control-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="custom-control-label" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, {label: 'I agree to the terms', custom: true})
  end

  test "check_box is wrapped correctly with id option and custom option set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-checkbox">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="custom-control-input" id="custom_id" name="user[terms]" type="checkbox" value="1" />
        <label class="custom-control-label" for="custom_id">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, {label: 'I agree to the terms', id: "custom_id", custom: true})
  end

  test "check_box is wrapped correctly with custom and inline options set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-checkbox custom-control-inline">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="custom-control-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="custom-control-label" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, {label: 'I agree to the terms', inline: true, custom: true})
  end

  test "check_box is wrapped correctly with custom and disabled options set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-checkbox">
        <input name="user[terms]" type="hidden" value="0" disabled="disabled" />
        <input class="custom-control-input" id="user_terms" name="user[terms]" type="checkbox" value="1" disabled="disabled" />
        <label class="custom-control-label" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, {label: 'I agree to the terms', disabled: true, custom: true})
  end

  test "check_box is wrapped correctly with custom, inline and disabled options set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-checkbox custom-control-inline">
        <input name="user[terms]" type="hidden" value="0" disabled="disabled" />
        <input class="custom-control-input" id="user_terms" name="user[terms]" type="checkbox" value="1" disabled="disabled" />
        <label class="custom-control-label" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, {label: 'I agree to the terms', inline: true, disabled: true, custom: true})
  end

  test "check_box skip label" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input position-static" id="user_terms" name="user[terms]" type="checkbox" value="1" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, label: 'I agree to the terms', skip_label: true)
  end

  test "check_box hide label" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input position-static" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label sr-only" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, label: 'I agree to the terms', hide_label: true)
  end

  test "check_box skip label with custom option set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-checkbox">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="custom-control-input position-static" id="user_terms" name="user[terms]" type="checkbox" value="1" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, {label: 'I agree to the terms', custom: true, skip_label: true})
  end

  test "check_box hide label with custom option set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-checkbox">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="custom-control-input position-static" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="custom-control-label sr-only" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, {label: 'I agree to the terms', custom: true, hide_label: true})
  end

  test 'collection_check_boxes renders error after last check box' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    @user.errors.add(:misc, "a box must be checked")

    expected = <<-HTML.strip_heredoc
    <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
      <input name="utf8" type="hidden" value="&#x2713;"/>
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, actual
  end

  test 'collection_check_boxes renders multiple check boxes with error correctly' do
    @user.errors.add(:misc, "error for test")
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
        <div class="form-group">
          <label for="user_misc">Misc</label>
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
    assert_equivalent_xml expected, actual
  end

  test 'check_box renders error when asked' do
    @user.errors.add(:terms, "You must accept the terms.")
    expected = <<-HTML.strip_heredoc
    <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
      <input name="utf8" type="hidden" value="&#x2713;"/>
      <div class="form-check">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input is-invalid" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
        <div class="invalid-feedback">You must accept the terms.</div>
      </div>
    </form>
    HTML
    actual = bootstrap_form_for(@user) do |f|
      f.check_box(:terms, label: 'I agree to the terms', error_message: true)
    end
    assert_equivalent_xml expected, actual
  end

  test "check_box with error is wrapped correctly with custom option set" do
    @user.errors.add(:terms, "You must accept the terms.")
    expected = <<-HTML.strip_heredoc
    <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
      <input name="utf8" type="hidden" value="&#x2713;"/>
      <div class="custom-control custom-checkbox">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="custom-control-input is-invalid" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="custom-control-label" for="user_terms">I agree to the terms</label>
        <div class="invalid-feedback">You must accept the terms.</div>
      </div>
    </form>
    HTML
    actual = bootstrap_form_for(@user) do |f|
      f.check_box(:terms, {label: 'I agree to the terms', custom: true, error_message: true})
    end
    assert_equivalent_xml expected, actual
  end

  test "check box with custom wrapper class" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check custom-class">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, label: 'I agree to the terms', wrapper_class: "custom-class")
  end

  test "inline check box with custom wrapper class" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check form-check-inline custom-class">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, label: 'I agree to the terms', inline: true, wrapper_class: "custom-class")
  end

  test "custom check box with custom wrapper class" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-checkbox custom-class">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="custom-control-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="custom-control-label" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, {label: 'I agree to the terms', custom: true, wrapper_class: "custom-class"})
  end

  test "custom inline check box with custom wrapper class" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-checkbox custom-control-inline custom-class">
        <input name="user[terms]" type="hidden" value="0" />
        <input class="custom-control-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="custom-control-label" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.check_box(:terms, {label: 'I agree to the terms', inline: true, custom: true, wrapper_class: "custom-class"})
  end
end
