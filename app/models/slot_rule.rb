class SlotRule < ApplicationRecord
  belongs_to :service
  has_many :events, dependent: :destroy
  has_many :event_rules

  enum status: { active: 0, inactive: 1 }

  validates :time, uniqueness: { scope: [:service_id, :wday] }

  delegate :time_zone, :accepts_slot_notes, to: :service

  def date_time(date)
    raise ArgumentError.new "Date does not belong to slot rule wday" unless wday == date.wday 
    ActiveSupport::TimeZone[time_zone].parse(date.to_s + " " + time)
  end
end
