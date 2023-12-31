namespace :date_events_reminder_emails do
  desc "Send event reminder email to all users with event on a given date"

  task :send => [ :environment ] do
    Event.booked.where(date: Date.tomorrow).find_each do |event|
      next if event.user.owns?(event.service)

      EventMailer.with(event: event).reminder_email.deliver_now
      puts "-> -> Email sent to #{event.user.email}"
    end
  end
  # bin/rake date_events_reminder_emails:send
end
