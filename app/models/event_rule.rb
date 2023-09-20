class EventRule < ApplicationRecord
  RECURRENCE_DAYS = { weekly: 7, biweekly: 14 }

  belongs_to :slot_rule
  belongs_to :user

  enum recurrence: { weekly: 0, biweekly: 1 }
  enum status: { active: 0, inactive: 1 }

  delegate :service, to: :slot_rule

  alias_attribute :date, :start_date

  def user_date_time(user)
    slot_rule.date_time(start_date).in_time_zone(user.time_zone)
  end

  def create_events_from(event)
    event_date = event.date
    event_name = event.name

    10.times do
      event_date = event_date + RECURRENCE_DAYS[recurrence.to_sym]
      user.events.create slot_rule:, date: event_date, name: event_name
    end
  end
end
