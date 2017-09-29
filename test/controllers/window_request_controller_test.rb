require 'test_helper'

class WindowRequestControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get window_request_index_url
    assert_response :success
  end

end
