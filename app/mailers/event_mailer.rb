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

  # EventMailer.with(event: event).confirmation_created_email.deliver_later
  def confirmation_created_email
    @event = params[:event]
    event_datetime = @event.user_date_time(@event.user)

    ical = Icalendar::Calendar.new
    ical.timezone do |t|
      t.tzid = ActiveSupport::TimeZone::MAPPING[@event.user.time_zone]
    end
    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::DateTime.new(event_datetime)
    event.dtend = Icalendar::Values::DateTime.new(event_datetime + 1.hour)
    event.organizer = "mailto:#{@event.service.user.email}"
    event.summary = "Cita #{@event.service.name}"
    event.uid = "citascc_#{@event.id}"

    ical.add_event(event)
    ical.append_custom_property('METHOD', 'PUBLISH')
    attachments['event.ics'] = { :mime_type => 'text/calendar', content: ical.to_ical }

    mail(
      to: @event.user.email,
      from: email_address_with_name('info@decktra.com', @event.service.user.name.titleize),
      reply_to: @event.service.user.email,
      subject: "Confirmación cita #{I18n.l event_datetime, format: :short}"
    )
  end

  # EventMailer.with(event: event).created_email.deliver_later
  def created_email
    @event = params[:event]
    event_datetime = @event.user_date_time(@event.service.user)

    ical = Icalendar::Calendar.new
    ical.timezone do |t|
      t.tzid = ActiveSupport::TimeZone::MAPPING[@event.service.user.time_zone]
    end
    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::DateTime.new(event_datetime)
    event.dtend = Icalendar::Values::DateTime.new(event_datetime + 1.hour)
    event.organizer = "mailto:#{@event.user.email}"
    event.summary = "Cita #{(@event.name || @event.user.name).titleize}"
    event.uid = "citascc_#{@event.id}"

    ical.add_event(event)
    ical.append_custom_property('METHOD', 'PUBLISH')
    attachments['event.ics'] = { :mime_type => 'text/calendar', content: ical.to_ical }

    mail(
      to: @event.service.user.email,
      from: email_address_with_name('info@decktra.com', @event.user.name.titleize),
      reply_to: @event.user&.email || @event.service.user.email,
      subject: "Nueva cita #{I18n.l event_datetime, format: :short}"
    )
  end

  # EventMailer.with(event: event, user: user).destroyed_email.deliver_later
  def destroyed_email
    @event = params[:event]
    @user = params[:user]
    event_datetime = @event.user_date_time(@user)
    email_destroyer = @user.owns?(@event) ?
                      @event.service.user.email : @event.user.email

    # ical = Icalendar::Calendar.new
    # ical.timezone do |t|
    #   t.tzid = ActiveSupport::TimeZone::MAPPING[@event.service.user.time_zone]
    # end
    # event = Icalendar::Event.new
    # event.dtstart = Icalendar::Values::DateTime.new(event_datetime)
    # event.dtend = Icalendar::Values::DateTime.new(event_datetime + 1.hour)
    # event.organizer = "mailto:#{@event.user.email}"
    # event.summary = "Cita #{(@event.name || @event.user.name).titleize}"
    # event.uid = "citascc_#{@event.id}"

    # ical.add_event(event)
    # ical.append_custom_property('METHOD', 'PUBLISH')
    # attachments['event.ics'] = { :mime_type => 'text/calendar', content: ical.to_ical }

    mail(
      to: @user.email,
      from: email_address_with_name('info@decktra.com', email_destroyer),
      reply_to: email_destroyer,
      subject: "Cita anulada #{I18n.l event_datetime, format: :short}"
    )
  end
end
