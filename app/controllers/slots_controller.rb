class SlotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service

  def index
    @date = params[:date]&.to_date || Time.now.in_time_zone(@service.time_zone).to_date

    @slots = Slots::DatesBuilder.new(date: @date, service: @service, user: current_user).build
  end

  private

  def set_service
    @service = Service.find params[:service_id]
    session[:service_id] = @service.id
    session[:locale] = @service.locale
  end
end
