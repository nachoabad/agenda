require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service = services(:one)
    @event   = events(:one)
    sign_in users(:user1)
  end

  test "should get index" do
    get service_events_url(@service)
    assert_response :success
  end

  test "should get new" do
    get new_service_event_url(@service, rule_id: slot_rules(:one).id, service_time_zone_date: Date.today.next_occurring(:monday))
    assert_response :success
  end

  test "should create event" do
    assert_difference("Event.count") do
      post service_events_url(@service), params: { event: { 
        slot_rule_id: slot_rules(:one).id,
        status: "booked",
        date: Date.today.next_occurring(:monday)
      } }
    end

    assert_redirected_to event_url(Event.last)
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  # test "should get edit" do
  #   get edit_event_url(@event)
  #   assert_response :success
  # end

  # test "should update event" do
  #   patch event_url(@event), params: { event: { slot_rule_id: @event.slot_rule_id, status: @event.status, user_id: @event.user_id } }
  #   assert_redirected_to event_url(@event)
  # end

  test "should destroy event" do
    assert_difference("Event.count", -1) do
      delete event_url(@event)
    end

    assert_redirected_to service_slots_url(@service)
  end
end
