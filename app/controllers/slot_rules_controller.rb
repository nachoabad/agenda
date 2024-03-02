class SlotRulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service, except: %i[ show update destroy]
  before_action :set_slot_rule, only: %i[ show edit update destroy ]

  def index
    @slot_rules = @service.slot_rules.order(:wday, :time).group_by(&:wday)
  end

  def show
  end

  def new
    @slot_rule = @service.slot_rules.new
  end

  def edit
  end

  def create
    wdays = params[:slot_rule]["wdays"].reject! { |x| x == "0" }
    time = "#{params[:slot_rule][:"time(4i)"]}:#{params[:slot_rule][:"time(5i)"]}"

    wdays.each do |wday|
      @slot_rule = @service.slot_rules.create(
        time: time,
        wday: wday,
      )
    end

    redirect_to service_slot_rules_url(@service), notice: "Slot rule was successfully created."
  end

  def update
    case params[:status]
    when "active"
      @slot_rule.active!
    when "inactive"
      @slot_rule.inactive!
    end

    redirect_to service_slot_rules_url(@slot_rule.service), notice: t(:slot_rule_updated)
  end

  # def destroy
  #   @slot_rule.destroy

  #   respond_to do |format|
  #     format.html { redirect_to slot_rules_url, notice: "Slot rule was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private
    def set_slot_rule
      @slot_rule = SlotRule.find(params[:id])
      redirect_to service_slot_rules_path(@slot_rule.service) unless current_user.owns?(@slot_rule.service)
    end

    def slot_rule_params
      params.require(:slot_rule).permit(:time, :wday, :user_id)
    end

    def set_service
      @service = current_user.services.find params[:service_id]
    end
end
