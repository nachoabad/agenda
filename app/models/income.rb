class Income
  include ActiveModel::Model

  attr_reader :period, :totals

  def initialize(period:, totals:)
    @period = period
    @totals = totals
  end
end