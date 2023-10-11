class IncomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @service = current_user.services.first
    @date = params[:date]&.to_date || Date.today

    @incomes = Incomes::PeriodsBuilder.new(date: @date, service: @service, user: current_user).build
  end

  def show
  end
end
