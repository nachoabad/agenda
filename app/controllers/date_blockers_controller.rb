class DateBlockersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service, only: %i[ new create ]
  before_action :set_date_to_block, only: %i[ new create ]

  def create
    @service.events.where(date: @date_to_block).destroy_all

    slot_rules_ids = @service.slot_rules.active.where(wday: @date_to_block.wday).pluck :id
    Event.create(slot_rules_ids.map do |slot_rule_id|
      {
        status: "blocked",
        date: @date_to_block,
        user: current_user,
        slot_rule_id:
      }
    end.to_a)

    redirect_to service_slots_url(@service, date: @date_to_block), notice: t(:date_blocked)
  end

  private

    def set_service
      @service = current_user.services.find params[:service_id]
    end

    def set_date_to_block
      @date_to_block = params[:date_to_block].to_date
    end
end
