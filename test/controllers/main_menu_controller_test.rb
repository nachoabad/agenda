require "test_helper"

class MainMenuControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin1)
    @service = services(:one)
  end

  test "should get index" do
    get service_main_menu_url(@service)
    assert_response :success
  end
end
