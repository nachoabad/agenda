class TimeZonesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service, only: %i[ edit update ]

  def edit
  end

  def update
    current_user.update time_zone: params[:time_zone]
    redirect_to service_slots_url(@service), notice: "Zona horario actulizada éxitosamente"
  end

  private
    
  def set_service
    @service = Service.find session[:service_id]
  end
end
