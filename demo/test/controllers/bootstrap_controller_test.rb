require "test_helper"

class BootstrapControllerTest < ActionDispatch::IntegrationTest
  test "should get form" do
    get root_path
    assert_response :success
  end
end
