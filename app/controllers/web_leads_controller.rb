class WebLeadsController < ApplicationController
  before_action :set_web_lead, only: %i[ show edit update destroy ]

  # GET /web_leads or /web_leads.json
  def index
    @web_leads = WebLead.all
  end

  # GET /web_leads/1 or /web_leads/1.json
  def show
  end

  # GET /web_leads/new
  def new
    @web_lead = WebLead.new
  end

  # GET /web_leads/1/edit
  def edit
  end

  # POST /web_leads or /web_leads.json
  def create
    @web_lead = WebLead.new(web_lead_params)

    respond_to do |format|
      if @web_lead.save
        WebLeadMailer.with(web_lead: @web_lead).notify_email.deliver_later
        format.html { redirect_to thanks_url(name: @web_lead.name) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /web_leads/1 or /web_leads/1.json
  def update
    respond_to do |format|
      if @web_lead.update(web_lead_params)
        format.html { redirect_to web_lead_url(@web_lead), notice: "Web lead was successfully updated." }
        format.json { render :show, status: :ok, location: @web_lead }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @web_lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /web_leads/1 or /web_leads/1.json
  def destroy
    @web_lead.destroy

    respond_to do |format|
      format.html { redirect_to web_leads_url, notice: "Web lead was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_web_lead
      @web_lead = WebLead.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def web_lead_params
      params.require(:web_lead).permit(:name, :email, :phone, :message)
    end
end
