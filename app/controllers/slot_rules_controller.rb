class SlotRulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service
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

  # PATCH/PUT /slot_rules/1 or /slot_rules/1.json
  def update
    respond_to do |format|
      if @slot_rule.update(slot_rule_params)
        format.html { redirect_to slot_rule_url(@slot_rule), notice: "Slot rule was successfully updated." }
        format.json { render :show, status: :ok, location: @slot_rule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @slot_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slot_rules/1 or /slot_rules/1.json
  def destroy
    @slot_rule.destroy

    respond_to do |format|
      format.html { redirect_to slot_rules_url, notice: "Slot rule was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slot_rule
      @slot_rule = SlotRule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def slot_rule_params
      params.require(:slot_rule).permit(:time, :wday, :user_id)
    end

    def set_service
      @service = current_user.services.find params[:service_id]
    end
end
