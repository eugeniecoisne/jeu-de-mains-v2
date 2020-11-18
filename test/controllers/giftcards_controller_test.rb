require 'test_helper'

class GiftcardsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get giftcards_new_url
    assert_response :success
  end

  test "should get create" do
    get giftcards_create_url
    assert_response :success
  end

  test "should get update" do
    get giftcards_update_url
    assert_response :success
  end

  test "should get show" do
    get giftcards_show_url
    assert_response :success
  end

end
