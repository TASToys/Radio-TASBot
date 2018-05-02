require 'test_helper'

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get whatis" do
    get static_whatis_url
    assert_response :success
  end

  test "should get help" do
    get static_help_url
    assert_response :success
  end

end
