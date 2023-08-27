class ServicesController < ApplicationController
  before_action :authenticate_user!

  def index
    @services = current_user.services
    @services = Service.all unless @services.any?
  end
end
