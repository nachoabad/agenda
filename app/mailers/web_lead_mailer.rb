class WebLeadMailer < ApplicationMailer
  def notify_email
    @web_lead = params[:web_lead]
    mail(to: "liao2512@gmail.com", subject: 'New Citas CC Web Lead')
  end
end
