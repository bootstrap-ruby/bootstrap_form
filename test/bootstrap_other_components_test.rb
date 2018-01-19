require_relative "./test_helper"

class BootstrapOtherComponentsTest < ActionView::TestCase
  include BootstrapForm::Helper

  setup :setup_test_fixture

  test "static control" do
    output = @horizontal_builder.static_control :email

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-sm-2 required" for="user_email">Email</label>
        <div class="col-sm-10">
          <p class="form-control-static">steve@example.com</p>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "static control doesn't require an actual attribute" do
    output = @horizontal_builder.static_control nil, label: "My Label" do
      "this is a test"
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-sm-2" for="user_">My Label</label>
        <div class="col-sm-10">
          <p class="form-control-static">this is a test</p>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "static control doesn't require a name" do
    output = @horizontal_builder.static_control label: "Custom Label" do
      "Custom Control"
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-sm-2" for="user_">Custom Label</label>
        <div class="col-sm-10">
          <p class="form-control-static">Custom Control</p>
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
        <label class="col-sm-2 required" for="user_email">Email</label>
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
        <label class="col-sm-2" for="user_">My Label</label>
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
        <label class="col-sm-2" for="user_">Custom Label</label>
        <div class="col-sm-10">Custom Control</div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "submit button" do
    expected = %{<input class="btn btn-primary" name="commit" type="submit" value="Create User" />}
    assert_equivalent_xml expected, @builder.submit
  end

  test "submit button with defined name" do
    expected = %{<input class="btn btn-primary" name="commit" type="submit" value="Test" />}
    assert_equivalent_xml expected, @builder.submit("Test")
  end

  test "submit button with custom class" do
    expected = %{<input class="test" name="commit" type="submit" value="Create User" />}
    assert_equivalent_xml expected, @builder.submit(class: "test")
  end

  test "submit button with block" do
    expected = <<-HTML.strip_heredoc
      <input class="btn btn-primary" name="commit" type="submit" value="Create User"/>
      <a href="/" class="btn btn-link">Cancel</a>
    HTML

    result = @builder.submit do
      %{<a href="/" class="btn btn-link">Cancel</a>}.html_safe
    end

    assert_equivalent_xml expected, result
  end

  test "submit button for horizontal form" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <div class="col-sm-10 offset-md-2">
          <input class="btn btn-primary" name="commit" type="submit" value="Create User"/>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, @horizontal_builder.submit
  end

end
