class Service < ApplicationRecord
  belongs_to :user
  has_many :slot_rules
  has_many :events, through: :slot_rules
  has_many :payments, through: :events
end
