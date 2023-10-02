class EventMailer < ApplicationMailer

  # EventMailer.with(event: event).reminder_email.deliver_now
  def reminder_email
    @event = params[:event]
    
    mail(
      to: @event.user.email,
      from: email_address_with_name('info@decktra.com', @event.service.user.name),
      reply_to: @event.service.user.email,
      subject: "🔔 Recordatorio Cita #{@event.service.name}"
    )
  end

  # EventMailer.with(event: event).created_email.deliver_later
  def created_email
    @event = params[:event]

    mail(
      to: @event.service.user.email,
      from: email_address_with_name('info@decktra.com', @event.user.name.titleize),
      reply_to: @event.user.email,
      subject: "🎉 Nueva cita #{I18n.l @event.user_date_time(@event.service.user), format: :short}"
    )
  end
end
