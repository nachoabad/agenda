namespace :date_events_reminder_emails do
  desc "Send event reminder email to all users with event on a given date"

  task :send => [ :environment ] do
    Event.booked.where(date: Date.tomorrow).find_each do |event|
      EventMailer.with(event: event).reminder_email.deliver_now
    end
  end
  # bin/rake date_events_reminder_emails:send
end
