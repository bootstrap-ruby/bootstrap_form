require_relative "./test_helper"

class BootstrapRadioButtonTest < ActionView::TestCase
  include BootstrapForm::Helper

  setup :setup_test_fixture

  test "radio_button is wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="form-check-label" for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button')
  end

  test "radio_button disabled label is set correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check disabled">
        <input class="form-check-input" disabled="disabled" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="form-check-label" for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', disabled: true)
  end

  test "radio_button label class is set correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="form-check-label btn" for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', label_class: 'btn')
  end

  test "radio_button 'id' attribute is used to specify label 'for' attribute" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input class="form-check-input" id="custom_id" name="user[misc]" type="radio" value="1" />
        <label class="form-check-label" for="custom_id">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', id: 'custom_id')
  end

  test "radio_button inline label is set correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check form-check-inline">
        <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="form-check-label" for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', inline: true)
  end

  test "radio_button disabled inline label is set correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check form-check-inline disabled">
        <input class="form-check-input" disabled="disabled" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="form-check-label" for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', inline: true, disabled: true)
  end

  test "radio_button inline label class is set correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check form-check-inline">
        <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="form-check-label btn" for="user_misc_1">
          This is a radio button
        </label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', inline: true, label_class: 'btn')
  end

  test 'collection_radio_buttons renders the form_group correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">This is a radio button collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foobar
          </label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders multiple radios correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, :street)
  end

  test 'collection_radio_buttons renders inline radios correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, inline: true)
  end

  test 'collection_radio_buttons renders with checked option correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, :street, checked: 1)
  end

  test 'collection_radio_buttons renders label defined by Proc correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">This is a radio button collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> rabooF</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, Proc.new { |a| a.street.reverse }, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders value defined by Proc correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">This is a radio button collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, Proc.new { |a| "address_#{a.id}" }, :street, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders multiple radios with label defined by Proc correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, Proc.new { |a| a.street.reverse })
  end

  test 'collection_radio_buttons renders multiple radios with value defined by Proc correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, Proc.new { |a| "address_#{a.id}" }, :street)
  end

  test 'collection_radio_buttons renders label defined by lambda correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">This is a radio button collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> rabooF</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, lambda { |a| a.street.reverse }, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders value defined by lambda correctly' do
    collection = [Address.new(id: 1, street: 'Foobar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">This is a radio button collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, lambda { |a| "address_#{a.id}" }, :street, label: 'This is a radio button collection', help: 'With a help!')
  end

  test 'collection_radio_buttons renders multiple radios with label defined by lambda correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, :id, lambda { |a| a.street.reverse })
  end

  test 'collection_radio_buttons renders multiple radios with value defined by lambda correctly' do
    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
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

    assert_equivalent_xml expected, @builder.collection_radio_buttons(:misc, collection, lambda { |a| "address_#{a.id}" }, :street)
  end

  test "radio_button is wrapped correctly with custom option set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-radio">
        <input class="custom-control-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="custom-control-label" for="user_misc_1">This is a radio button</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', {label: 'This is a radio button', custom: true})
  end

  test "radio_button is wrapped correctly with custom and inline options set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-radio custom-control-inline">
        <input class="custom-control-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="custom-control-label" for="user_misc_1">This is a radio button</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', {label: 'This is a radio button', inline: true, custom: true})
  end

  test "radio_button is wrapped correctly with custom and disabled options set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-radio">
        <input class="custom-control-input" id="user_misc_1" name="user[misc]" type="radio" value="1" disabled="disabled"/>
        <label class="custom-control-label" for="user_misc_1">This is a radio button</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', {label: 'This is a radio button', disabled: true, custom: true})
  end
  test "radio_button is wrapped correctly with custom, inline and disabled options set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-radio custom-control-inline">
        <input class="custom-control-input" id="user_misc_1" name="user[misc]" type="radio" value="1" disabled="disabled"/>
        <label class="custom-control-label" for="user_misc_1">This is a radio button</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', {label: 'This is a radio button', inline: true, disabled: true, custom: true})
  end

  test "radio button skip label" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input class="form-check-input position-static" id="user_misc_1" name="user[misc]" type="radio" value="1" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', skip_label: true)
  end
  test "radio button hide label" do
    expected = <<-HTML.strip_heredoc
      <div class="form-check">
        <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="form-check-label sr-only" for="user_misc_1">This is a radio button</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', label: 'This is a radio button', hide_label: true)
  end


  test "radio button skip label with custom option set" do
    expected = <<-HTML.strip_heredoc
    <div class="custom-control custom-radio">
      <input class="custom-control-input position-static" id="user_misc_1" name="user[misc]" type="radio" value="1" />
    </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', {label: 'This is a radio button', custom: true, skip_label: true})
  end

  test "radio button hide label with custom option set" do
    expected = <<-HTML.strip_heredoc
      <div class="custom-control custom-radio">
        <input class="custom-control-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
        <label class="custom-control-label sr-only" for="user_misc_1">This is a radio button</label>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.radio_button(:misc, '1', {label: 'This is a radio button', custom: true, hide_label: true})
  end
end
