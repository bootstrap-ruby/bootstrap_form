require 'test_helper'

class BootstrapRadioButtonTest < ActionView::TestCase
  include BootstrapForm::Helper

  def setup
    setup_test_fixture
  end

  test "radio_button is wrapped correctly" do
    expected = %{<div class="radio"><label for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> This is a radio button</label></div>}
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button')
  end

  test "radio_button disabled label is set correctly" do
    expected = %{<div class="radio disabled"><label for="user_misc_1"><input disabled="disabled" id="user_misc_1" name="user[misc]" type="radio" value="1" /> This is a radio button</label></div>}
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', disabled: true)
  end

  test "radio_button label class is set correctly" do
    expected = %{<div class="radio"><label class="btn" for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> This is a radio button</label></div>}
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', label_class: 'btn')
  end

  test "radio_button inline label is set correctly" do
    expected = %{<label class="radio-inline" for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> This is a radio button</label>}
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', inline: true)
  end

  test "radio_button disabled inline label is set correctly" do
    expected = %{<label class="radio-inline disabled" for="user_misc_1"><input disabled="disabled" id="user_misc_1" name="user[misc]" type="radio" value="1" /> This is a radio button</label>}
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', inline: true, disabled: true)
  end

  test "radio_button inline label class is set correctly" do
    expected = %{<label class="radio-inline btn" for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> This is a radio button</label>}
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', inline: true, label_class: 'btn')
  end

  test 'collection_radio_buttons renders the form_group correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">This is a radio button collection</label><div class="radio"><label for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foobar</label></div><span class="help-block">With a help!</span></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders multiple radios correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="radio"><label for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foo</label></div><div class="radio"><label for="user_misc_2"><input id="user_misc_2" name="user[misc]" type="radio" value="2" /> Bar</label></div></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, :street)
  end

  test 'collection_radio_buttons renders inline radios correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><label class="radio-inline" for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foo</label><label class="radio-inline" for="user_misc_2"><input id="user_misc_2" name="user[misc]" type="radio" value="2" /> Bar</label></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, inline: true)
  end

  test 'collection_radio_buttons renders with checked option correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="radio"><label for="user_misc_1"><input checked="checked" id="user_misc_1" name="user[misc]" type="radio" value="1" /> Foo</label></div><div class="radio"><label for="user_misc_2"><input id="user_misc_2" name="user[misc]" type="radio" value="2" /> Bar</label></div></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, checked: 1)
  end

  test 'collection_radio_buttons renders label defined by Proc correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">This is a radio button collection</label><div class="radio"><label for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> rabooF</label></div><span class="help-block">With a help!</span></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, Proc.new { |a| a.street.reverse }, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders value defined by Proc correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">This is a radio button collection</label><div class="radio"><label for="user_misc_address_1"><input id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" /> Foobar</label></div><span class="help-block">With a help!</span></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, Proc.new { |a| "address_#{a.id}" }, :street, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders multiple radios with label defined by Proc correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="radio"><label for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> ooF</label></div><div class="radio"><label for="user_misc_2"><input id="user_misc_2" name="user[misc]" type="radio" value="2" /> raB</label></div></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, Proc.new { |a| a.street.reverse })
  end

  test 'collection_radio_buttons renders multiple radios with value defined by Proc correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="radio"><label for="user_misc_address_1"><input id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" /> Foo</label></div><div class="radio"><label for="user_misc_address_2"><input id="user_misc_address_2" name="user[misc]" type="radio" value="address_2" /> Bar</label></div></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, Proc.new { |a| "address_#{a.id}" }, :street)
  end

  test 'collection_radio_buttons renders label defined by lambda correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">This is a radio button collection</label><div class="radio"><label for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> rabooF</label></div><span class="help-block">With a help!</span></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, lambda { |a| a.street.reverse }, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders value defined by lambda correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">This is a radio button collection</label><div class="radio"><label for="user_misc_address_1"><input id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" /> Foobar</label></div><span class="help-block">With a help!</span></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, lambda { |a| "address_#{a.id}" }, :street, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders multiple radios with label defined by lambda correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="radio"><label for="user_misc_1"><input id="user_misc_1" name="user[misc]" type="radio" value="1" /> ooF</label></div><div class="radio"><label for="user_misc_2"><input id="user_misc_2" name="user[misc]" type="radio" value="2" /> raB</label></div></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, lambda { |a| a.street.reverse })
  end

  test 'collection_radio_buttons renders multiple radios with value defined by lambda correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = %{<div class="form-group"><label class="control-label" for="user_misc">Misc</label><div class="radio"><label for="user_misc_address_1"><input id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" /> Foo</label></div><div class="radio"><label for="user_misc_address_2"><input id="user_misc_address_2" name="user[misc]" type="radio" value="address_2" /> Bar</label></div></div>}

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, lambda { |a| "address_#{a.id}" }, :street)
  end

end
