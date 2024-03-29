class Event < ApplicationRecord
  after_create :create_pending_payment

  belongs_to :user, optional: true
  belongs_to :slot_rule

  has_one :payment, dependent: :destroy

  enum status: { booked: 0, blocked: 1 }

  accepts_nested_attributes_for :user

  validates :slot_rule_id, uniqueness: { scope: :date, message: "Fecha/hora no disponible" }

  delegate :service, to: :slot_rule

  def user_date_time(user)
    slot_rule.date_time(date).in_time_zone(user.time_zone)
  end

  def past?
    date.past?
  end

  def destroyable?(user)
    user.owns?(service) ||
    (booked? &&
    (user_date_time(user) - Time.now.in_time_zone(user.time_zone) > 6.hours))
  end

  private

  def create_pending_payment
    create_payment unless blocked? || payment || !service.accepts_payments
  end
end
