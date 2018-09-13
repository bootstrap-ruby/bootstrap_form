require_relative "./test_helper"

class BootstrapOtherComponentsTest < ActionView::TestCase
  include BootstrapForm::Helper

  setup :setup_test_fixture

  test "static control" do
    output = @horizontal_builder.static_control :email

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
        <div class="col-sm-10">
          <input class="form-control-plaintext" id="user_email" name="user[email]" readonly="readonly" type="text" value="steve@example.com"/>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "static control can have custom_id" do
    output = @horizontal_builder.static_control :email, id: 'custom_id'

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2 required" for="custom_id">Email</label>
        <div class="col-sm-10">
          <input class="form-control-plaintext" id="custom_id" name="user[email]" readonly="readonly" type="text" value="steve@example.com"/>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "static control doesn't require an actual attribute" do
    output = @horizontal_builder.static_control nil, label: "My Label", value: "this is a test"

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2" for="user_">My Label</label>
        <div class="col-sm-10">
          <input class="form-control-plaintext" id="user_" name="user[]" readonly="readonly" type="text" value="this is a test"/>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "static control doesn't require a name" do
    output = @horizontal_builder.static_control label: "Custom Label", value: "Custom Control"

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2" for="user_">Custom Label</label>
        <div class="col-sm-10">
          <input class="form-control-plaintext" id="user_" name="user[]" readonly="readonly" type="text" value="Custom Control"/>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "static control support a nil value" do
    output = @horizontal_builder.static_control label: "Custom Label", value: nil

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2" for="user_">Custom Label</label>
        <div class="col-sm-10">
          <input class="form-control-plaintext" id="user_" name="user[]" readonly="readonly" type="text"/>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "static control won't overwrite a control_class that is passed by the user" do
    output = @horizontal_builder.static_control :email, control_class: "test_class"

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
        <div class="col-sm-10">
          <input class="test_class form-control-plaintext" id="user_email" name="user[email]" readonly="readonly" type="text" value="steve@example.com"/>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "custom control does't wrap given block in a p tag" do
    output = @horizontal_builder.custom_control :email do
      "this is a test"
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
        <div class="col-sm-10">this is a test</div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "custom control doesn't require an actual attribute" do
    output = @horizontal_builder.custom_control nil, label: "My Label" do
      "this is a test"
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2" for="user_">My Label</label>
        <div class="col-sm-10">this is a test</div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "custom control doesn't require a name" do
    output = @horizontal_builder.custom_control label: "Custom Label" do
      "Custom Control"
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2" for="user_">Custom Label</label>
        <div class="col-sm-10">Custom Control</div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "regular button uses proper css classes" do
    expected = %{<button class="btn btn-secondary" name="button" type="submit"><span>I'm HTML!</span> in a button!</button>}
    assert_equivalent_xml expected,
                          @builder.button("<span>I'm HTML!</span> in a button!".html_safe)
  end

  test "regular button can have extra css classes" do
    expected = %{<button class="btn btn-secondary test-button" name="button" type="submit"><span>I'm HTML!</span> in a button!</button>}
    assert_equivalent_xml expected,
                          @builder.button("<span>I'm HTML!</span> in a button!".html_safe, extra_class: 'test-button')
  end

  test "submit button defaults to rails action name" do
    expected = %{<input class="btn btn-secondary" name="commit" type="submit" value="Create User" />}
    assert_equivalent_xml expected, @builder.submit
  end

  test "submit button uses default button classes" do
    expected = %{<input class="btn btn-secondary" name="commit" type="submit" value="Submit Form" />}
    assert_equivalent_xml expected, @builder.submit("Submit Form")
  end

  test "submit button can have extra css classes" do
    expected = %{<input class="btn btn-secondary test-button" name="commit" type="submit" value="Submit Form" />}
    assert_equivalent_xml expected, @builder.submit("Submit Form", extra_class: 'test-button')
  end

  test "override submit button classes" do
    expected = %{<input class="btn btn-primary" name="commit" type="submit" value="Submit Form" />}
    assert_equivalent_xml expected, @builder.submit("Submit Form", class: "btn btn-primary")
  end

  test "primary button uses proper css classes" do
    expected = %{<input class="btn btn-primary" name="commit" type="submit" value="Submit Form" />}
    assert_equivalent_xml expected, @builder.primary("Submit Form")
  end

  test "primary button can have extra css classes" do
    expected = %{<input class="btn btn-primary test-button" name="commit" type="submit" value="Submit Form" />}
    assert_equivalent_xml expected, @builder.primary("Submit Form", extra_class: 'test-button')
  end

  test "primary button can render as HTML button" do
    expected = %{<button class="btn btn-primary" name="button" type="submit"><span>I'm HTML!</span> Submit Form</button>}
    assert_equivalent_xml expected,
                          @builder.primary("<span>I'm HTML!</span> Submit Form".html_safe,
                                           render_as_button: true)
  end

  test "primary button with content block renders as HTML button" do
    output = @builder.primary do
      "<span>I'm HTML!</span> Submit Form".html_safe
    end
    expected = %{<button class="btn btn-primary" name="button" type="submit"><span>I'm HTML!</span> Submit Form</button>}
    assert_equivalent_xml expected, output
  end

  test "override primary button classes" do
    expected = %{<input class="btn btn-primary disabled" name="commit" type="submit" value="Submit Form" />}
    assert_equivalent_xml expected, @builder.primary("Submit Form", class: "btn btn-primary disabled")
  end
end
