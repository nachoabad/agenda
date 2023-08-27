class EventMailer < ApplicationMailer

  # EventMailer.with(event: event).reminder_email.deliver_now
  def reminder_email
    @event = params[:event]
    
    mail(
      to: @event.user.email,
      from: email_address_with_name('info@decktra.com', @event.service.user.name),
      reply_to: @event.service.user.email,
      subject: "Recordatorio Cita #{@event.service.name}"
    )
  end
end
