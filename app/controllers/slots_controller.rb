class SlotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service

  def index
    #TODO: move slot logic to model
    @date = params[:date]&.to_date || Time.now.in_time_zone(@service.time_zone).to_date
    dates = @date..(@date + 6.days)

    slot_rules = @service.slot_rules.active.sort_by(&:time).group_by &:wday    
    events     = @service.events.where(date: dates)

    @slots = {}
    dates.each do |date|
      if slot_rules[date.wday]
        slot_rules[date.wday].each do|slot_rule|
          event = events.find_by(date:, slot_rule:)
          unless event && !current_user.owns?(event.service)
            slot_date_time = slot_rule.date_time(date).in_time_zone(current_user.time_zone)
            @slots[slot_date_time.to_date] ||= []
            @slots[slot_date_time.to_date] << Slot.new(
              slot_date_time,
              slot_rule,
              event,
              date
            )
          end
        end.compact
      else
        next
      end
    end

    @slots.compact_blank!
  end

  private

  def set_service
    @service = Service.find params[:service_id]
    session[:service_id] = @service.id
  end
end
