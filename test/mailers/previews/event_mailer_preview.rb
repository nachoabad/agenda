# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview
  def reminder_email
    EventMailer.with(event: Event.first).reminder_email
  end
end
