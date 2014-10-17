require 'test_helper'

class BootstrapCheckboxTest < ActionView::TestCase
  include BootstrapForm::Helper

  def setup
    setup_test_fixture
  end

  test "check_box is wrapped correctly" do
    expected = %{<div class="checkbox"><label for="user_terms"><input name="user[terms]" type="hidden" value="0" /><input id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms</label></div>}
    assert_equal expected, @builder.check_box(:terms, label: 'I agree to the terms')
  end

  test "disabled check_box has proper wrapper classes" do
    expected = %{<div class="checkbox disabled"><label for="user_terms"><input disabled="disabled" name="user[terms]" type="hidden" value="0" /><input disabled="disabled" id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms</label></div>}
    assert_equal expected, @builder.check_box(:terms, label: 'I agree to the terms', disabled: true)
  end

  test "check_box label allows html" do
    expected = %{<div class="checkbox"><label for="user_terms"><input name="user[terms]" type="hidden" value="0" /><input id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the <a href="#">terms</a></label></div>}
    assert_equal expected, @builder.check_box(:terms, label: %{I agree to the <a href="#">terms</a>}.html_safe)
  end

  test "check_box accepts a block to define the label" do
    expected = %{<div class="checkbox"><label for="user_terms"><input name="user[terms]" type="hidden" value="0" /><input id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms</label></div>}
    assert_equal expected, @builder.check_box(:terms) { "I agree to the terms" }
  end

  test "check_box responds to checked_value and unchecked_value arguments" do
    expected = %{<div class="checkbox"><label for="user_terms"><input name="user[terms]" type="hidden" value="no" /><input id="user_terms" name="user[terms]" type="checkbox" value="yes" /> I agree to the terms</label></div>}
    assert_equal expected, @builder.check_box(:terms, {label: 'I agree to the terms'}, 'yes', 'no')
  end

  test "inline checkboxes" do
    expected = %{<label class="checkbox-inline" for="user_terms"><input name="user[terms]" type="hidden" value="0" /><input id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms</label>}
    assert_equal expected, @builder.check_box(:terms, label: 'I agree to the terms', inline: true)
  end

  test "disabled inline check_box" do
    expected = %{<label class="checkbox-inline disabled" for="user_terms"><input disabled="disabled" name="user[terms]" type="hidden" value="0" /><input disabled="disabled" id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms</label>}
    assert_equal expected, @builder.check_box(:terms, label: 'I agree to the terms', inline: true, disabled: true)
  end

  test 'collection_check_boxes renders the form_group correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = %{<input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group"><label class="control-label" for="user_misc">This is a checkbox collection</label><div class="checkbox"><label for="user_misc_1"><input id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foobar</label></div><span class="help-block">With a help!</span></div>}

    assert_equal expected, @builder.collection_check_boxes(:misc, collection, :id, :street, label: 'This is a checkbox collection', help: 'With a help!')
  end

  test 'collection_check_boxes renders multiple checkboxes correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="checkbox"><label for="user_misc_1"><input id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foo</label></div><div class="checkbox"><label for="user_misc_2"><input id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> Bar</label></div></div>}

    assert_equal expected, @builder.collection_check_boxes(:misc, collection, :id, :street)
  end

  test 'collection_check_boxes renders inline checkboxes correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group"><label class="control-label" for="user_misc">Misc</label><label class="checkbox-inline" for="user_misc_1"><input id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foo</label><label class="checkbox-inline" for="user_misc_2"><input id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> Bar</label></div>}

    assert_equal expected, @builder.collection_check_boxes(:misc, collection, :id, :street, inline: true)
  end

  test 'collection_check_boxes renders with checked option correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="checkbox"><label for="user_misc_1"><input checked="checked" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foo</label></div><div class="checkbox"><label for="user_misc_2"><input id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> Bar</label></div></div>}

    assert_equal expected, @builder.collection_check_boxes(:misc, collection, :id, :street, checked: 1)
    assert_equal expected, @builder.collection_check_boxes(:misc, collection, :id, :street, checked: collection.first)
  end

  test 'collection_check_boxes renders with multiple checked options correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="checkbox"><label for="user_misc_1"><input checked="checked" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foo</label></div><div class="checkbox"><label for="user_misc_2"><input checked="checked" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> Bar</label></div></div>}

    assert_equal expected, @builder.collection_check_boxes(:misc, collection, :id, :street, checked: [1, 2])
    assert_equal expected, @builder.collection_check_boxes(:misc, collection, :id, :street, checked: collection)
  end
end
