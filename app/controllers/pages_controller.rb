class PagesController < ApplicationController
  def index
    render layout: false
  end

  def thanks
    @name = params[:name]&.split&.first&.titleize

    render layout: false
  end
end
