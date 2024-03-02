class MainMenusController < ApplicationController
  before_action :authenticate_user!

  def show
    @service = Service.find(params[:service_id])
  end
end
