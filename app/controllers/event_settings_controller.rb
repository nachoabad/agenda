class EventSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[ update ]

  def update
    @event.update(
      settings: @event.settings.merge(color_tag: params[:color_tag])
    )

    redirect_to event_path(@event)
  end

  private

    def set_event
      @event = Event.find(params[:id])

      redirect_to service_slots_path(@event.service) unless current_user == @event.service.user 
    end
end
