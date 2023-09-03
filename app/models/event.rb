class Event < ApplicationRecord
  after_create :create_pending_payment

  belongs_to :user
  belongs_to :slot_rule

  has_one :payment, dependent: :destroy

  enum status: { booked: 0, blocked: 1 }

  validates :slot_rule_id, uniqueness: { scope: :date, message: "Fecha/hora no disponible" }

  delegate :service, to: :slot_rule

  def user_date_time(user)
    slot_rule.date_time(date).in_time_zone(user.time_zone)
  end

  def past?
    date.past?
  end

  private

  def create_pending_payment
    create_payment unless blocked? || payment
  end
end
