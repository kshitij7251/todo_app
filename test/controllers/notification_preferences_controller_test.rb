require "test_helper"

class NotificationPreferencesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get notification_preferences_index_url
    assert_response :success
  end

  test "should get update" do
    get notification_preferences_update_url
    assert_response :success
  end
end
