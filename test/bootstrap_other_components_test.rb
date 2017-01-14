require 'test_helper'

class BootstrapOtherComponentsTest < ActionView::TestCase
  include BootstrapForm::Helper

  def setup
    setup_test_fixture
  end

  test "static control" do
    output = @horizontal_builder.static_control :email

    expected = %{<div class="form-group"><label class="control-label col-sm-2 required" for="user_email">Email</label><div class="col-sm-10"><p class="form-control-static">steve@example.com</p></div></div>}
    assert_equivalent_xml expected, output
  end

  test "static control doesn't require an actual attribute" do
    output = @horizontal_builder.static_control nil, label: "My Label" do
      "this is a test"
    end

    expected = %{<div class="form-group"><label class="control-label col-sm-2" for="user_">My Label</label><div class="col-sm-10"><p class="form-control-static">this is a test</p></div></div>}
    assert_equivalent_xml expected, output
  end

  test "static control doesn't require a name" do
    output = @horizontal_builder.static_control label: "Custom Label" do
      "Custom Control"
    end

    expected = %{<div class="form-group"><label class="control-label col-sm-2" for="user_">Custom Label</label><div class="col-sm-10"><p class="form-control-static">Custom Control</p></div></div>}
    assert_equivalent_xml expected, output
  end

  test "custom control does't wrap given block in a p tag" do
    output = @horizontal_builder.custom_control :email do
      "this is a test"
    end

    expected = %{<div class="form-group"><label class="control-label col-sm-2 required" for="user_email">Email</label><div class="col-sm-10">this is a test</div></div>}
    assert_equal expected, output
  end

  test "custom control doesn't require an actual attribute" do
    output = @horizontal_builder.custom_control nil, label: "My Label" do
      "this is a test"
    end

    expected = %{<div class="form-group"><label class="control-label col-sm-2" for="user_">My Label</label><div class="col-sm-10">this is a test</div></div>}
    assert_equal expected, output
  end

  test "custom control doesn't require a name" do
    output = @horizontal_builder.custom_control label: "Custom Label" do
      "Custom Control"
    end

    expected = %{<div class="form-group"><label class="control-label col-sm-2" for="user_">Custom Label</label><div class="col-sm-10">Custom Control</div></div>}
    assert_equal expected, output
  end

  test "submit button defaults to rails action name" do
    expected = %{<input class="btn btn-default" name="commit" type="submit" value="Create User" />}
    assert_equivalent_xml expected, @builder.submit
  end

  test "submit button uses default button classes" do
    expected = %{<input class="btn btn-default" name="commit" type="submit" value="Submit Form" />}
    assert_equivalent_xml expected, @builder.submit("Submit Form")
  end

  test "override submit button classes" do
    expected = %{<input class="btn btn-primary" name="commit" type="submit" value="Submit Form" />}
    assert_equivalent_xml expected, @builder.submit("Submit Form", class: "btn btn-primary")
  end

  test "primary button uses proper css classes" do
    expected = %{<input class="btn btn-primary" name="commit" type="submit" value="Submit Form" />}
    assert_equivalent_xml expected, @builder.primary("Submit Form")
  end

  test "override primary button classes" do
    expected = %{<input class="btn btn-primary disabled" name="commit" type="submit" value="Submit Form" />}
    assert_equivalent_xml expected, @builder.primary("Submit Form", class: "btn btn-primary disabled")
  end
end
