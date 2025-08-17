class RemindersController < ApplicationController
  before_action :authenticate_user!

  def create
    @service = current_user.services.find(params[:service_id])
    
    # Find all booked events for tomorrow for this service
    tomorrow_events = Event.booked.joins(:slot_rule).where(
      slot_rules: { service: @service },
      date: Date.tomorrow
    ).where.not(user: current_user) # Exclude the service owner
    
    sent_count = 0
    reminder_details = []
    
    tomorrow_events.find_each do |event|
      EventMailer.with(event: event).reminder_email.deliver_now
      sent_count += 1
      
      # Collect details for the notification
      event_time = event.slot_rule.date_time(event.date)
      reminder_details << "#{event.user.name} (#{event.user.email}) - #{event_time.strftime('%d/%m/%Y %H:%M')}"
    end
    
    if sent_count > 0
      notice = "Se enviaron #{sent_count} recordatorios por email:\n#{reminder_details.join("\n")}"
    else
      notice = "No hay eventos programados para mañana"
    end
    
    redirect_to service_main_menu_path(@service), notice: notice
  end
end
