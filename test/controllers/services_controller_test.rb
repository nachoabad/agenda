require "test_helper"

class ServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service = services(:one)
    sign_in users(:user1)
  end

  test "should get show and redirect to service slots" do
    get service_url(@service.slug)
    assert_redirected_to "/services/#{@service.id}/slots"
  end
end
