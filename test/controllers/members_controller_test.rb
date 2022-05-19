require "test_helper"

class MembersControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get members_dashboard_url
    assert_response :success
  end
end
