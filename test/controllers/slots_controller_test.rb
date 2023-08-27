require "test_helper"

class SlotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service = services(:one)
    sign_in users(:user1)
  end

  test "should get index" do
    get service_slots_url(@service)
    assert_response :success
  end
end
