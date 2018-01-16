# The following allows us to test this file individually with:
# 'bundle exec rake test TEST=test/bootstrap_form_with_test.rb'
require 'rails'

if ::Rails::VERSION::STRING >= "5.1"
  require "test_helper"

  class BootstrapFormWithCheckboxTest < ActionView::TestCase
    include BootstrapForm::Helper

    def setup
      setup_test_fixture
    end

    test "check_box is wrapped correctly" do
      expected = <<-HTML.strip_heredoc
        <div class="form-check">
          <label class="form-check-label" for="user_terms">
            <input name="user[terms]" type="hidden" value="0" />
            <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms
          </label>
        </div>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected),
        @form_with_builder.check_box(:terms, label: "I agree to the terms")
      # assert_equivalent_xml expected.gsub(/user_terms/, "custom_id"),
      #   @form_with_builder.check_box(:terms, label: "I agree to the terms", id: "custom_id")
    end

    test "disabled check_box has proper wrapper classes" do
      expected = <<-HTML.strip_heredoc
        <div class="form-check disabled">
          <label class="form-check-label" for="user_terms">
            <input disabled="disabled" name="user[terms]" type="hidden" value="0" />
            <input class="form-check-input" disabled="disabled" id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms
          </label>
        </div>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected),
        @form_with_builder.check_box(:terms, label: "I agree to the terms", disabled: true)
      # assert_equivalent_xml expected.gsub(/user_terms/, "custom_id"),
        # @form_with_builder.check_box(:terms, label: "I agree to the terms", disabled: true, id: "custom_id")
    end

    test "check_box label allows html" do
      expected = <<-HTML.strip_heredoc
        <div class="form-check">
          <label class="form-check-label" for="user_terms">
            <input name="user[terms]" type="hidden" value="0" />
            <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the <a href="#">terms</a></label>
          </div>
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected),
        @form_with_builder.check_box(:terms, label: %(I agree to the <a href="#">terms</a>).html_safe)
      # assert_equivalent_xml expected.gsub(/user_terms/, "custom_id"),
      #   @form_with_builder.check_box(:terms, label: %(I agree to the <a href="#">terms</a>).html_safe, id: "custom_id")
    end

    test "check_box accepts a block to define the label" do
      expected = <<-HTML.strip_heredoc
        <div class="form-check">
          <label class="form-check-label" for="user_terms">
            <input name="user[terms]" type="hidden" value="0" />
            <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms</label>
          </div>)
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected),
        @form_with_builder.check_box(:terms) { "I agree to the terms" }
      # assert_equivalent_xml expected, @form_with_builder.check_box(:terms, id: "custom_id") { "I agree to the terms" }
    end

    test "check_box accepts a custom label class" do
      expected = <<-HTML.strip_heredoc
        <div class="form-check">
          <label class="form-check-label btn" for="user_terms">
            <input name="user[terms]" type="hidden" value="0" />
            <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" /> Terms</label>
          </div>)
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected),
        @form_with_builder.check_box(:terms, label_class: "btn")
      # assert_equivalent_xml expected, @form_with_builder.check_box(:terms, label_class: "btn", id: "custom_id")
    end

    test "check_box responds to checked_value and unchecked_value arguments" do
      expected = <<-HTML.strip_heredoc
        <div class="form-check">
          <label class="form-check-label" for="user_terms">
            <input name="user[terms]" type="hidden" value="no" />
            <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="yes" /> I agree to the terms</label>
          </div>)
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected),
        @form_with_builder.check_box(:terms, { label: "I agree to the terms" }, "yes", "no")
      # assert_equivalent_xml expected, @form_with_builder.check_box(:terms, { label: "I agree to the terms", id: "custom_id" }, "yes", "no")
    end

    test "inline checkboxes" do
      expected = <<-HTML.strip_heredoc
        <label class="form-check-inline" for="user_terms">
          <input name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms</label>)
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected),
        @form_with_builder.check_box(:terms, label: "I agree to the terms", inline: true)
      # assert_equivalent_xml expected, @form_with_builder.check_box(:terms, label: "I agree to the terms", inline: true, id: "custom_id")
    end

    test "disabled inline check_box" do
      expected = <<-HTML.strip_heredoc
        <label class="form-check-inline disabled" for="user_terms">
          <input disabled="disabled" name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" disabled="disabled" id="user_terms" name="user[terms]" type="checkbox" value="1" /> I agree to the terms</label>)
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected),
        @form_with_builder.check_box(:terms, label: "I agree to the terms", inline: true, disabled: true)
      # assert_equivalent_xml expected, @form_with_builder.check_box(:terms, label: "I agree to the terms", inline: true, disabled: true, id: "custom_id")
    end

    test "inline checkboxes with custom label class" do
      expected = <<-HTML.strip_heredoc
        <label class="form-check-inline btn" for="user_terms">
          <input name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" /> Terms</label>)
      HTML
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected),
        @form_with_builder.check_box(:terms, inline: true, label_class: "btn")
      # assert_equivalent_xml expected, @form_with_builder.check_box(:terms, inline: true, label_class: "btn", id: "custom_id")
    end

    # test "collection_check_boxes renders the form_group correctly" do
    #   collection = [Address.new(id: 1, street: "Foobar")]
    #   expected = <<-HTML.strip_heredoc
      # <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
      # <label for="user_misc">This is a checkbox collection</label><div class="form-check">
      # <label class="form-check-label" for="user_misc_1">
      # <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foobar</label>
      # </div><span class="form-text text-muted">With a help!</span>
      # </div>)
      # HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, :id, :street, label: "This is a checkbox collection", help: "With a help!")
    # end
    #
    # test "collection_check_boxes renders multiple checkboxes correctly" do
    #   collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    #   expected = <<-HTML.strip_heredoc
      # <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
      # <label for="user_misc">Misc</label><div class="form-check">
      # <label class="form-check-label" for="user_misc_1">
      # <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foo</label>
      # </div><div class="form-check">
      # <label class="form-check-label" for="user_misc_2">
      # <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> Bar</label>
      # </div>
      # </div>)
      # HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, :id, :street)
    # end
    #
    # test "collection_check_boxes renders inline checkboxes correctly" do
    #   collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    #   expected = <<-HTML.strip_heredoc
    #   <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
    # <label for="user_misc">Misc</label>
    # <label class="form-check-inline" for="user_misc_1">
    # <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foo</label>
    # <label class="form-check-inline" for="user_misc_2">
    # <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> Bar</label>
    # </div>)
    # HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, :id, :street, inline: true)
    # end
    #
    # test "collection_check_boxes renders with checked option correctly" do
    #   collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    #   expected = <<-HTML.strip_heredoc
      # <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
      # <label for="user_misc">Misc</label><div class="form-check">
      # <label class="form-check-label" for="user_misc_1">
      # <input checked="checked" class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foo</label>
      # </div><div class="form-check">
      # <label class="form-check-label" for="user_misc_2">
      # <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> Bar</label>
      # </div>
      # </div>)
      # HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, :id, :street, checked: 1)
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, :id, :street, checked: collection.first)
    # end
    #
    # test "collection_check_boxes renders with multiple checked options correctly" do
    #   collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    #   expected = <<-HTML.strip_heredoc
      # <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
      # <label for="user_misc">Misc</label><div class="form-check">
      # <label class="form-check-label" for="user_misc_1">
      # <input checked="checked" class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> Foo</label>
      # </div><div class="form-check">
      # <label class="form-check-label" for="user_misc_2">
      # <input checked="checked" class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> Bar</label>
      # </div>
      # </div>)
      # HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, :id, :street, checked: [1, 2])
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, :id, :street, checked: collection)
    # end
    #
    # test "collection_check_boxes sanitizes values when generating label `for`" do
    #   collection = [Address.new(id: 1, street: "Foo St")]
    #   expected = <<-HTML.strip_heredoc
    #   <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
    # <label for="user_misc">Misc</label><div class="form-check">
    # <label class="form-check-label" for="user_misc_foo_st">
    # <input class="form-check-input" id="user_misc_foo_st" name="user[misc][]" type="checkbox" value="Foo St" /> Foo St</label>
    # </div>
    # </div>)
    # HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, :street, :street)
    # end
    #
    # test "collection_check_boxes renders multiple checkboxes with labels defined by Proc :text_method correctly" do
    #   collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    #   expected = <<-HTML.strip_heredoc
      # <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
      # <label for="user_misc">Misc</label><div class="form-check">
      # <label class="form-check-label" for="user_misc_1">
      # <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> ooF</label>
      # </div><div class="form-check">
      # <label class="form-check-label" for="user_misc_2">
      # <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> raB</label>
      # </div>
      # </div>)
      # HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, :id, proc { |a| a.street.reverse })
    # end
    #
    # test "collection_check_boxes renders multiple checkboxes with values defined by Proc :value_method correctly" do
    #   collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    #   expected = <<-HTML.strip_heredoc
      # <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
      # <label for="user_misc">Misc</label><div class="form-check">
      # <label class="form-check-label" for="user_misc_address_1">
      # <input class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" /> Foo</label>
      # </div><div class="form-check">
      # <label class="form-check-label" for="user_misc_address_2">
      # <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" /> Bar</label>
      # </div>
      # </div>)
      #  HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" }, :street)
    # end
    #
    # test "collection_check_boxes renders multiple checkboxes with labels defined by lambda :text_method correctly" do
    #   collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    #   expected = <<-HTML.strip_heredoc
      # <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
      # <label for="user_misc">Misc</label><div class="form-check">
      # <label class="form-check-label" for="user_misc_1">
      # <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" /> ooF</label>
      # </div><div class="form-check">
      # <label class="form-check-label" for="user_misc_2">
      # <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" /> raB</label>
      # </div>
      # </div>)
      #  HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, :id, ->(a) { a.street.reverse })
    # end
    #
    # test "collection_check_boxes renders multiple checkboxes with values defined by lambda :value_method correctly" do
    #   collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    #   expected = <<-HTML.strip_heredoc
      # <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
      # <label for="user_misc">Misc</label><div class="form-check">
      # <label class="form-check-label" for="user_misc_address_1">
      # <input class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" /> Foo</label>
      # </div><div class="form-check">
      # <label class="form-check-label" for="user_misc_address_2">
      # <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" /> Bar</label>
      # </div>
      # </div>)
      #  HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" }, :street)
    # end
    #
    # test "collection_check_boxes renders with checked option correctly with Proc :value_method" do
    #   collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    #   expected = <<-HTML.strip_heredoc
      # <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
      # <label for="user_misc">Misc</label><div class="form-check">
      # <label class="form-check-label" for="user_misc_address_1">
      # <input checked="checked" class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" /> Foo</label>
      # </div><div class="form-check">
      # <label class="form-check-label" for="user_misc_address_2">
      # <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" /> Bar</label>
      # </div>
      # </div>)
      #  HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" }, :street, checked: "address_1")
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" }, :street, checked: collection.first)
    # end
    #
    # test "collection_check_boxes renders with multiple checked options correctly with lambda :value_method" do
    #   collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    #   expected = <<-HTML.strip_heredoc
      # <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" /><div class="form-group">
      # <label for="user_misc">Misc</label><div class="form-check">
      # <label class="form-check-label" for="user_misc_address_1">
      # <input checked="checked" class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" /> Foo</label>
      # </div><div class="form-check">
      # <label class="form-check-label" for="user_misc_address_2">
      # <input checked="checked" class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" /> Bar</label>
      # </div>
      # </div>)
      #    HTML
    #
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" }, :street, checked: %w(address_1 address_2))
    #   assert_equivalent_xml expected, @form_with_builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" }, :street, checked: collection)
    # end
  end
end
