module Incomes
  class PeriodsBuilder
    DATES_RANGE = 12.months
    
    def initialize(date:, service:, user:)
      @date = date
      @service = service
      @user = user
    end

    def build
      dates = (@date - DATES_RANGE)..@date
      periods = @service.payments.not_pending.where(date: dates).group_by do |payment|
        payment.date.beginning_of_month
      end.transform_values do |period_payments|
        period_payments.group_by(&:currency).transform_values do |currency_payments|
          currency_payments.sum(&:amount)
        end
      end

      incomes = []
      periods.keys.each do |period|
        incomes << Income.new(period:, totals: periods[period])
      end
      incomes
    end
  end
end
