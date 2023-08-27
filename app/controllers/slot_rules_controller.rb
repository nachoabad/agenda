class SlotRulesController < ApplicationController
  before_action :set_slot_rule, only: %i[ show edit update destroy ]

  # GET /slot_rules or /slot_rules.json
  def index
    @slot_rules = SlotRule.all
  end

  # GET /slot_rules/1 or /slot_rules/1.json
  def show
  end

  # GET /slot_rules/new
  def new
    @slot_rule = SlotRule.new
  end

  # GET /slot_rules/1/edit
  def edit
  end

  # POST /slot_rules or /slot_rules.json
  def create
    @slot_rule = SlotRule.new(slot_rule_params)

    respond_to do |format|
      if @slot_rule.save
        format.html { redirect_to slot_rule_url(@slot_rule), notice: "Slot rule was successfully created." }
        format.json { render :show, status: :created, location: @slot_rule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @slot_rule.errors, status: :unprocessable_entity }
      end
    end
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
end
