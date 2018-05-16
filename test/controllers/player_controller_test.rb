require 'test_helper'

class PlayerControllerTest < ActionDispatch::IntegrationTest
  test "should get player" do
    get player_player_url
    assert_response :success
  end

end
