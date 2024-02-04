class ServicesController < ApplicationController
  before_action :authenticate_user!

  def index
    @services = current_user.services
    @services = Service.all unless @services.any?
  end

  def show
    service = Service.find_by slug: params[:id]
    session[:locale] = service.locale
    redirect_to service_slots_path(service)
  end
end
