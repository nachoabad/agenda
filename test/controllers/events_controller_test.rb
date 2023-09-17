require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service = services(:one)
    @event   = events(:one)
    sign_in users(:admin1)
  end

  test "should get index" do
    get service_events_url(@service)
    assert_response :success
  end

  test "should get new" do
    get new_service_event_url(@service, rule_id: slot_rules(:one).id, service_time_zone_date: Date.today.next_occurring(:monday))
    assert_response :success
  end

  test "should create an event" do
    assert_difference("Event.count", 1) do
      post service_events_url(@service), params: { event: {
        slot_rule_id: slot_rules(:one).id,
        status: "booked",
        date: Date.today.next_occurring(:monday)
      } }
    end

    assert_redirected_to event_url(Event.last)
  end

  test "should create an event and user event" do
    assert_difference("Event.count", 1) do
      assert_difference("User.count", 1) do
        post service_events_url(@service), params: { event: {
          slot_rule_id: slot_rules(:one).id,
          status: "booked",
          date: Date.today.next_occurring(:monday),
          user_attributes: { name: "Graciela", email: "gra@cie.la", phone: "123", time_zone: "Madrid" }
        } }
      end
    end

    assert_redirected_to event_url(Event.last)
  end

  test "should create an event and assign it to existing user" do
    assert_difference("Event.count", 1) do
      assert_difference("User.count", 0) do
        post service_events_url(@service), params: { event: {
          slot_rule_id: slot_rules(:one).id,
          status: "booked",
          date: Date.today.next_occurring(:monday),
          user_attributes: { name: "Graciela", email: users(:user1).email, phone: "123", time_zone: "Madrid" }
        } }
      end
    end

    assert_redirected_to event_url(Event.last)
  end

  test "should create an event but no user event" do
    assert_difference("Event.count", 1) do
      assert_difference("User.count", 0) do
        post service_events_url(@service), params: { event: {
          slot_rule_id: slot_rules(:one).id,
          status: "booked",
          date: Date.today.next_occurring(:monday),
          user_attributes: { name: "Graciela" }
        } }
      end
    end

    assert_redirected_to event_url(Event.last)
  end

  test "should create recurrent events" do
    assert_difference("Event.count", 11) do
      post service_events_url(@service), params: { event: {
        slot_rule_id: slot_rules(:one).id,
        status: "booked",
        date: Date.today.next_occurring(:monday),
        recurrence: :biweekly
      } }
    end
  end

  test "should create event rule" do
    assert_difference("EventRule.count", 1) do
      post service_events_url(@service), params: { event: {
        slot_rule_id: slot_rules(:one).id,
        status: "booked",
        date: Date.today.next_occurring(:monday),
        recurrence: :biweekly
      } }
    end
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  test "should not destroy a past event" do
    assert_difference("Event.count", 0) do
      delete event_url(@event)
    end

    assert_redirected_to service_slots_url(@service)
  end

  test "should destroy future event" do
    @event.update date: @event.date + 14.days

    assert_difference("Event.count", -1) do
      delete event_url(@event)
    end

    assert_redirected_to service_slots_url(@service)
  end

  test "should destroy next recurrent events" do
    post service_events_url(@service), params: { event: {
      slot_rule_id: slot_rules(:one).id,
      status: "booked",
      date: Date.today.next_occurring(:monday),
      recurrence: :biweekly
    } }

    assert_difference("Event.count", -5) do
      delete event_url(Event.last(5).first, params: { destroy_event_rule: EventRule.last.id })
    end
  end
end
