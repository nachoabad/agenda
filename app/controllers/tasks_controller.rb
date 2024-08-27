class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_nacho

  # this code is deuplicated on the rake task
  def date_events_reminder_emails
    @sent_emails = []

    Event.booked.where(date: Date.tomorrow).find_each do |event|
      next if event.user.owns?(event.service)

      EventMailer.with(event: event).reminder_email.deliver_now
      @sent_emails << event.user.email
    end
  end

  # this code is deuplicated on the rake task
  def event_rules_future_events
    @events_before = Event.count

    EventRule.active.find_each do |event_rule|
      if (events = Event.where(
          user: event_rule.user,
          slot_rule: event_rule.slot_rule,
          date: Date.today..
        ).presence) && events.size < 10

        event_rule.create_events_from(events.order(:date).last)
      end
    end

    @events_after = Event.count
  end

  private

  def check_nacho
    redirect_to root_path unless current_user.email == 'liao2512@gmail.com'
  end
end
