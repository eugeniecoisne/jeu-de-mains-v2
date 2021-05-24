require 'test_helper'

class SitemapsControllerTest < ActionDispatch::IntegrationTest
  test "should get sitemap" do
    get sitemaps_sitemap_url
    assert_response :success
  end

end
