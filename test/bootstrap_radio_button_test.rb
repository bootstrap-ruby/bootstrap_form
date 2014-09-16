require 'test_helper'

class BootstrapRadioButtonTest < ActionView::TestCase
  include BootstrapForm::Helper

  def setup
    setup_test_fixture
  end

  test "radio_button is wrapped correctly" do
    expected = %{<div class="radio"><label for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> This is a radio button</label></div>}
    assert_equal expected, @builder.radio_button(:misc, '1', label: 'This is a radio button')
  end

  test "radio_button inline label is set correctly" do
    expected = %{<label class="radio-inline" for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> This is a radio button</label>}
    assert_equal expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', inline: true)
  end

  test 'collection_radio_buttons renders the form_group correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">This is a radio button collection</label><div class="radio"><label for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foobar</label></div><span class="help-block">With a help!</span></div>}

    assert_equal expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders multiple radios correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="radio"><label for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foo</label></div><div class="radio"><label for="user_misc_2"><input id="user_misc_2" name="user[misc]" type="radio" value="2" /> Bar</label></div></div>}

    assert_equal expected, @builder.collection_radio_buttons(:misc, collection, :id, :street)
  end

  test 'collection_radio_buttons renders inline radios correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><label class="radio-inline" for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foo</label><label class="radio-inline" for="user_misc_2"><input id="user_misc_2" name="user[misc]" type="radio" value="2" /> Bar</label></div>}

    assert_equal expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, inline: true)
  end

  test 'collection_radio_buttons renders with checked option correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="radio"><label for="user_misc_1"><input checked="checked" id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foo</label></div><div class="radio"><label for="user_misc_2"><input id="user_misc_2" name="user[misc]" type="radio" value="2" /> Bar</label></div></div>}

    assert_equal expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, checked: 1)
  end
end
