require 'test_helper'

class FeeInvoicesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get fee_invoices_create_url
    assert_response :success
  end

end
