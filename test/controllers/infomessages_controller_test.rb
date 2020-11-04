require 'test_helper'

class InfomessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get infomessages_create_url
    assert_response :success
  end

end
