unless Rails.env.production?
  class NonProductionEmailInterceptor
    def self.delivering_email(email)
      email.to = [Rails.application.credentials.emails.dev]
      email.subject = "DEV #{email.subject} #{email.to}"
    end
  end

  ActionMailer::Base.register_interceptor(NonProductionEmailInterceptor)
end