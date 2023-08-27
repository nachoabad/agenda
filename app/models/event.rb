class Event < ApplicationRecord
  belongs_to :user
  belongs_to :slot_rule

  enum status: { booked: 0, blocked: 1 }

  delegate :service, to: :slot_rule

  def user_date_time(user)
    slot_rule.date_time(date).in_time_zone(user.time_zone)
  end
end
