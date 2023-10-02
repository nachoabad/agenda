# Preview all emails at http://localhost:3000/rails/mailers/web_lead_mailer
class WebLeadMailerPreview < ActionMailer::Preview
  def notify_email
    WebLeadMailer.with(web_lead: WebLead.new(
      name: "Graciela Benatuil",
      phone: "+583722282",
      email: "gra@cie.la"
    )).notify_email
  end
end
