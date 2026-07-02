# frozen_string_literal: true

require_relative "test_helper"

class BootstrapComboboxTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  CARET = BootstrapForm::Inputs::Combobox::CARET_ICON
  CHECK = BootstrapForm::Inputs::Combobox::CHECK_ICON

  test "combobox is wrapped correctly" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_status">Status</label>
        <button aria-expanded="false" aria-haspopup="listbox" class="form-control combobox-toggle" data-bs-name="user[status]" data-bs-placeholder="Select a status…" data-bs-toggle="combobox" id="user_status" type="button">
          <span class="combobox-value combobox-placeholder">Select a status…</span>
          #{CARET}
        </button>
        <div class="menu">
          <button class="menu-item" data-bs-value="1" type="button">activated</button>
          <button class="menu-item" data-bs-value="2" type="button">blocked</button>
        </div>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.combobox(:status, [["activated", 1], ["blocked", 2]],
                                             placeholder: "Select a status…")
  end

  test "combobox marks the selected choice and shows its label" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_status">Status</label>
        <button aria-expanded="false" aria-haspopup="listbox" class="form-control combobox-toggle" data-bs-name="user[status]" data-bs-toggle="combobox" id="user_status" type="button">
          <span class="combobox-value">blocked</span>
          #{CARET}
        </button>
        <div class="menu">
          <button class="menu-item" data-bs-value="1" type="button">activated</button>
          <button aria-selected="true" class="menu-item selected" data-bs-value="2" type="button">blocked</button>
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.combobox(:status, [["activated", 1], ["blocked", 2]], selected: 2)
  end

  test "combobox with multiple and search" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <button aria-expanded="false" aria-haspopup="listbox" class="form-control combobox-toggle" data-bs-multiple="true" data-bs-name="user[misc]" data-bs-search="true" data-bs-toggle="combobox" id="user_misc" type="button">
          <span class="combobox-value">2 selected</span>
          #{CARET}
        </button>
        <div class="menu">
          <div class="combobox-search">
            <input aria-label="Search…" autocomplete="off" class="form-control combobox-search-input" placeholder="Search…" type="text">
          </div>
          <button aria-selected="true" class="menu-item selected" data-bs-value="1" type="button">Foo#{CHECK}</button>
          <button aria-selected="true" class="menu-item selected" data-bs-value="2" type="button">Bar#{CHECK}</button>
          <button class="menu-item" data-bs-value="3" type="button">Baz#{CHECK}</button>
          <div class="combobox-no-results d-none">No results found</div>
        </div>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.combobox(:misc, [["Foo", 1], ["Bar", 2], ["Baz", 3]],
                                             multiple: true, search: true, selected: [1, 2])
  end

  test "combobox uses the object value for selection" do
    @user.misc = 2
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <button aria-expanded="false" aria-haspopup="listbox" class="form-control combobox-toggle" data-bs-name="user[misc]" data-bs-toggle="combobox" id="user_misc" type="button">
          <span class="combobox-value">Bar</span>
          #{CARET}
        </button>
        <div class="menu">
          <button class="menu-item" data-bs-value="1" type="button">Foo</button>
          <button aria-selected="true" class="menu-item selected" data-bs-value="2" type="button">Bar</button>
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.combobox(:misc, [["Foo", 1], ["Bar", 2]])
  end

  test "combobox with error" do
    @user.errors.add(:misc, "error for test")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <div class="form-field mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <button aria-describedby="user_misc_feedback" aria-expanded="false" aria-haspopup="listbox" class="form-control combobox-toggle is-invalid" data-bs-name="user[misc]" data-bs-toggle="combobox" id="user_misc" type="button">
            <span class="combobox-value combobox-placeholder"></span>
            #{CARET}
          </button>
          <div class="menu">
            <button class="menu-item" data-bs-value="1" type="button">Foo</button>
          </div>
          <div class="invalid-feedback" id="user_misc_feedback">error for test</div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |f| f.combobox(:misc, [["Foo", 1]]) }
  end

  test "combobox with flat choices and help text" do
    expected = <<~HTML
      <div class="form-field mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <button aria-expanded="false" aria-haspopup="listbox" class="form-control combobox-toggle" data-bs-name="user[misc]" data-bs-toggle="combobox" id="user_misc" type="button">
          <span class="combobox-value combobox-placeholder"></span>
          #{CARET}
        </button>
        <div class="menu">
          <button class="menu-item" data-bs-value="Foo" type="button">Foo</button>
          <button class="menu-item" data-bs-value="Bar" type="button">Bar</button>
        </div>
        <small class="form-text">Pick one</small>
      </div>
    HTML
    assert_equivalent_html expected, @builder.combobox(:misc, %w[Foo Bar], help: "Pick one")
  end
end
