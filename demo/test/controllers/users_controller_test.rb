require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should post create" do
    post users_url
    assert_redirected_to root_path
  end

  test "should patch update" do
    patch user_url(users(:one))
    assert_redirected_to root_path
  end
end
