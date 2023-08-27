class SlotRule < ApplicationRecord
  belongs_to :service
  has_many :events

  enum status: { active: 0, inactive: 1 }

  delegate :time_zone, to: :service

  def date_time(date)
    raise ArgumentError.new "Date does not belong to slot rule wday" unless wday == date.wday 
    ActiveSupport::TimeZone[time_zone].parse(date.to_s + " " + time)
  end
end
