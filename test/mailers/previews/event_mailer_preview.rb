# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview
  def reminder_email
    EventMailer.with(event: Event.first).reminder_email
  end

  def confirmation_email
    EventMailer.with(event: Event.last).confirmation_email
  end

  def created_email
    EventMailer.with(event: Event.last).created_email
  end
end
