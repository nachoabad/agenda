class ServicesController < ApplicationController
  before_action :set_service, only: %i[ show ]
  before_action :authenticate_user!

  def index
    @services = current_user.services
    @services = Service.all unless @services.any?
  end

  def show
    redirect_to service_slots_path(@service)
  end

  private

  def set_service
    service = Service.find_by slug: params[:id]
    session[:service_id] = @service.id

    locale = service.locale || I18n.default_locale
    session[:locale] = locale
    I18n.locale = locale
  end
end
