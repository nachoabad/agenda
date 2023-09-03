class Payment < ApplicationRecord
  belongs_to :event

  enum status: { pending: 0, reported: 1, confirmed: 2 }
  enum currency: { usd: 0, eur: 1, bs: 2 }

  delegate :service, to: :event

  scope :past, -> { joins(:event).where('events.date' => ..Date.today) }
end
