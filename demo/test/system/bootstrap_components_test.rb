# frozen_string_literal: true

require "application_system_test_case"

# Drives the Bootstrap 6 components in the demo like a user would and checks
# that bootstrap_form's mark-up works with Bootstrap's JavaScript.
class BootstrapComponentsTest < ApplicationSystemTestCase
  setup do
    visit root_url
    all(".toggle").each { |btn| execute_script "arguments[0].remove()", btn }
  end

  test "combobox selection fills the hidden input" do
    toggle = find("#combobox_basic")
    toggle.click
    field = toggle.ancestor(".form-field")
    field.find(".menu-item", text: "Option two").click

    assert_equal "Option two", toggle.find(".combobox-value").text
    assert_equal "2", field.find("input[type=hidden]", visible: false)[:value]
  end

  test "multiple combobox counts and joins the selected values" do
    toggle = find("#combobox_multiple")
    assert_equal "2 selected", toggle.find(".combobox-value").text
    toggle.click
    field = toggle.ancestor(".form-field")
    field.find(".menu-item", text: "United Kingdom").click

    assert_equal "3 selected", toggle.find(".combobox-value").text
    assert_equal "us,ca,uk", field.find("input[type=hidden]", visible: false)[:value]
  end

  test "searchable combobox filters its items" do
    toggle = find("#combobox_search")
    toggle.click
    menu = toggle.ancestor(".form-field").find(".menu")
    menu.find(".combobox-search-input").fill_in with: "ger"

    assert_selector ".menu-item", text: "Germany", visible: true
    assert menu.has_no_selector?(".menu-item", text: "Canada", visible: true)
  end

  test "disabled combobox items and groups" do
    toggle = find("#combobox_groups")
    toggle.click
    menu = toggle.ancestor(".form-field").find(".menu")
    assert_equal %w[Frontend Backend], menu.all(".menu-header").map(&:text)

    find("#combobox_disabled_item").click
    assert find("#combobox_disabled_item").ancestor(".form-field").find(".menu-item[disabled]").disabled?
    assert find("#combobox_disabled").disabled?
  end

  test "chips are added with Enter and removed with their dismiss button" do
    input = find("#chips_skills")
    container = input.ancestor(".chip-input")
    input.send_keys("Ruby", :enter)

    assert_equal(%w[JavaScript TypeScript Ruby], container.all(".chip").pluck(:"data-bs-chip-value"))
    container.find(".chip", text: "Ruby").find(".chip-dismiss").click
    assert_equal(%w[JavaScript TypeScript], container.all(".chip").pluck(:"data-bs-chip-value"))
  end

  test "OTP input renders slots and keeps one real value" do
    input = find("#otp_basic", visible: :all)
    container = input.ancestor(".otp")
    assert_equal 6, container.all(".otp-slot", visible: :all).count

    input.send_keys("123456")
    assert_equal "123456", input.value
    assert_equal "123456", container.all(".otp-slot", visible: :all).map(&:text).join
  end

  test "datepicker popup and inline calendar write their values" do
    find("#datepicker_basic").click
    day = (Date.current.beginning_of_month + 14).iso8601
    execute_script <<~JS
      const popup = [...document.querySelectorAll(".vc")].find((el) => !el.closest("[data-bs-inline]") && el.offsetParent !== null)
      popup.id = "popup_calendar"
    JS
    find("#popup_calendar [data-vc-date='#{day}']").find("button, [data-vc-date-btn]", match: :first).click
    assert find("#datepicker_basic").value.present?
    # The popup stays open after a pick. Closing it with a click elsewhere
    # refocuses and scrolls to its input, which would swallow the next click.
    find("body").send_keys(:escape)
    assert_no_selector("#popup_calendar")

    calendar = find("#datepicker_inline", visible: false).ancestor("[data-bs-inline]")
    assert_equal "2026-06-10", find("#datepicker_inline", visible: false).value
    calendar.find("[data-vc-date='2026-06-12']").find("button, [data-vc-date-btn]", match: :first).click
    assert_equal "2026-06-12", find("#datepicker_inline", visible: false).value
  end

  test "password strength meter reacts to typing" do
    input = find("#strength_text")
    field = input.ancestor(".form-field")
    input.fill_in with: "abc"
    assert_equal "weak", field.find(".strength")[:"data-bs-strength"]

    input.fill_in with: "Str0ng!Passw0rd#2026"
    assert_equal "strong", field.find(".strength")[:"data-bs-strength"]
    assert field.find(".strength-text").text.present?
  end

  test "static strength levels need no JavaScript" do
    field = find("#strength_static_good").ancestor(".form-field")
    assert_equal 3, field.all(".strength-segment.active").count
    assert_equal "Good", field.find(".strength-text").text
  end

  test "client-side validation blocks submission and shows feedback" do
    within("#client_side_validation_form") do
      assert_no_selector ".invalid-feedback", visible: true
      click_button "Submit form"
      assert_selector "#client_validation_email ~ .invalid-feedback", text: "Please enter a valid email address.", visible: true
      assert_equal "true", find("#client_validation_email")["aria-invalid"]
    end
    assert_current_path root_path
  end

  test "range ticks and value bubble are rendered" do
    ticks = find("#range_ticks").ancestor(".form-range")
    assert_equal 5, ticks.all(".form-range-tick", visible: :all).count
    assert_equal(%w[Cold Mild Hot], ticks.all(".form-range-tick-label", visible: :all).map { |l| l.text(:all) })

    bubble = find("#range_bubble").ancestor(".form-range")
    assert bubble.has_selector?(".form-range-bubble", visible: :all)

    # The bubble follows the thumb through the `--bs-range-fill` property
    # Bootstrap's JS writes; it only moves when the compiled CSS carries the
    # `bs-` prefix, so this also guards the PostCSS step in the CSS build.
    bubble_left = ->{ evaluate_script("document.querySelector('#range_bubble ~ .form-range-bubble').getBoundingClientRect().left") }
    at_60 = bubble_left.call
    execute_script("const r = document.getElementById('range_bubble'); r.value = 10; r.dispatchEvent(new Event('input', { bubbles: true }))")
    assert_equal "0.1", bubble["style"][/--bs-range-fill:\s*([\d.]+)/, 1]
    assert_equal "10", bubble.find(".form-range-bubble .tooltip-inner", visible: :all).text(:all)
    assert_operator bubble_left.call, :<, at_60 - 50
  end

  test "switches, cards and indeterminate checkbox" do
    switch = find("#switch_default")
    switch.click
    assert switch.checked?

    assert_equal true, evaluate_script("document.getElementById('check_indeterminate').indeterminate")

    card = find("#field_plan_pro").ancestor(".form-field-card")
    card.find("label").click
    assert find("#field_plan_pro").checked?
  end

  test "toggle source code shows the generated HTML" do
    visit root_url
    first("button.toggle").click
    assert_selector ".example .code", visible: true, match: :first
    assert_selector ".example .CodeMirror", match: :first
  end
end
