class DateBlockersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service, only: %i[ new create ]
  before_action :set_date_to_block, only: %i[ new create ]

  def create
    @service.events.where(date: @date).destroy_all

    if blocking = params[:date_action] == 'block'
      slot_rules_ids = @service.slot_rules.active.where(wday: @date.wday).pluck :id
      Event.create(slot_rules_ids.map do |slot_rule_id|
        {
          status: "blocked",
          date: @date,
          user: current_user,
          slot_rule_id:
        }
      end.to_a)
    end

    redirect_to service_slots_url(@service, date: @date),
      notice: blocking ? t(:date_blocked) : t(:date_unblocked)
  end

  private

    def set_service
      @service = current_user.services.find params[:service_id]
    end

    def set_date_to_block
      @date = (params[:date]).to_date
    end
end
