require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  test "should get date_events_reminder_emails" do
    get tasks_date_events_reminder_emails_url
    assert_response :success
  end

  test "should get event_rules_future_events" do
    get tasks_event_rules_future_events_url
    assert_response :success
  end
end
