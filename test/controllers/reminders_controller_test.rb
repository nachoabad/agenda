require "test_helper"

class RemindersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service = services(:one)
    @user = users(:admin1)
    @slot_rule = slot_rules(:one)
    sign_in @user
  end

  test "should create reminders for tomorrow's events" do
    # Create a booked event for tomorrow
    tomorrow_event = Event.create!(
      status: :booked,
      date: Date.tomorrow,
      user: users(:user1),
      slot_rule: @slot_rule
    )

    # Test that the controller action completes successfully
    post service_reminders_url(@service)

    assert_redirected_to service_main_menu_path(@service)
    assert_equal "Se enviaron 1 recordatorios por email:\nUser 1 (user1@mail.com) - #{tomorrow_event.slot_rule.date_time(tomorrow_event.date).strftime('%d/%m/%Y %H:%M')}", flash[:notice]
  end

  test "should handle no events for tomorrow" do
    # Ensure no events exist for tomorrow
    Event.where(date: Date.tomorrow).destroy_all

    post service_reminders_url(@service)

    assert_redirected_to service_main_menu_path(@service)
    assert_equal "No hay eventos programados para mañana", flash[:notice]
  end

  test "should exclude service owner from reminders" do
    # Create a booked event for tomorrow owned by the current user (service owner)
    Event.create!(
      status: :booked,
      date: Date.tomorrow,
      user: @user,
      slot_rule: @slot_rule
    )

    post service_reminders_url(@service)

    assert_redirected_to service_main_menu_path(@service)
    assert_equal "No hay eventos programados para mañana", flash[:notice]
  end

  test "should only send reminders for booked events" do
    # Create a blocked event for tomorrow
    Event.create!(
      status: :blocked,
      date: Date.tomorrow,
      user: users(:user1),
      slot_rule: @slot_rule
    )

    post service_reminders_url(@service)

    assert_redirected_to service_main_menu_path(@service)
    assert_equal "No hay eventos programados para mañana", flash[:notice]
  end

  test "should send multiple reminders for multiple events" do
    # Create multiple booked events for tomorrow
    Event.create!(
      status: :booked,
      date: Date.tomorrow,
      user: users(:user1),
      slot_rule: @slot_rule
    )

    Event.create!(
      status: :booked,
      date: Date.tomorrow,
      user: users(:user1),
      slot_rule: slot_rules(:two)
    )

    # Test that the controller action completes successfully
    post service_reminders_url(@service)

    assert_redirected_to service_main_menu_path(@service)
    assert_match /Se enviaron 2 recordatorios por email:/, flash[:notice]
  end

  test "should require authentication" do
    sign_out @user
    post service_reminders_url(@service)
    assert_redirected_to new_user_session_path
  end

  test "should only allow service owner to create reminders" do
    # Sign in as a different user who doesn't own the service
    sign_in users(:user1)
    
    assert_raises(ActiveRecord::RecordNotFound) do
      post service_reminders_url(@service)
    end
  end
end
