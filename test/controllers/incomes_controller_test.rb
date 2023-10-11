require "test_helper"

class IncomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin1)
  end

  test "should get index" do
    get incomes_url
    assert_response :success
  end
end
