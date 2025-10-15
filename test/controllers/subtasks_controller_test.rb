require "test_helper"

class SubtasksControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get subtasks_create_url
    assert_response :success
  end

  test "should get destroy" do
    get subtasks_destroy_url
    assert_response :success
  end

  test "should get toggle" do
    get subtasks_toggle_url
    assert_response :success
  end
end
