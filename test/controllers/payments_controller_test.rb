require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment = payments(:one)
    sign_in users(:admin1)
  end

  test "should get index" do
    get payments_url
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_url(@payment)
    assert_response :success
  end

  test "should update payment" do
    patch payment_url(@payment), params: { payment: { amount: @payment.amount, comments: @payment.comments, date: @payment.date, event_id: @payment.event_id, reference: @payment.reference, status: @payment.status } }
    assert_redirected_to edit_payment_url(@payment)
  end
end
