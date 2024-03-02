module Slots
  class DatesBuilder
    DATES_RANGE = 6.days
    
    def initialize(date:, service:, user:)
      @date = date
      @service = service
      @user = user
    end

    def build
      dates = @date..(@date + DATES_RANGE)

      slot_rules = @service.slot_rules.sort_by(&:time).group_by &:wday
      events     = @service.events.where(date: dates)

      slots = {}
      dates.each do |date|
        if slot_rules[date.wday]
          slot_rules[date.wday].each do|slot_rule|
            event = events.find_by(date:, slot_rule:)
            unless event && !@user.owns?(event.service)
              slot_date_time = slot_rule.date_time(date).in_time_zone(@user.time_zone)
              slots[slot_date_time.to_date] ||= []
              slots[slot_date_time.to_date] << Slot.new(
                slot_date_time,
                slot_rule,
                event,
                date
              ) unless !event && slot_rule.inactive?
            end
          end.compact
        else
          next
        end
      end

      slots.compact_blank!
    end
  end
end
