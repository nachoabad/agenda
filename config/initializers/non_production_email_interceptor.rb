unless Rails.env.production?
  class NonProductionEmailInterceptor
    def self.delivering_email(email)
      email.subject = "DEV #{email.subject} #{email.to}"
      email.to = [Rails.application.credentials.emails.dev]
    end
  end

  ActionMailer::Base.register_interceptor(NonProductionEmailInterceptor)
end