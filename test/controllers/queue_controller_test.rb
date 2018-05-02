require 'test_helper'

class QueueControllerTest < ActionDispatch::IntegrationTest
  test "should get queue" do
    get queue_queue_url
    assert_response :success
  end

end
