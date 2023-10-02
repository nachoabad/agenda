require "test_helper"

class WebLeadsControllerTest < ActionDispatch::IntegrationTest
  test "should create web_lead" do
    assert_difference("WebLead.count") do
      post web_leads_url, params: { web_lead: { email: "user@mail.com", message: "Hola", name: "Graciela Benatuil", phone: "55555" } }
    end

    assert_redirected_to thanks_url(name: WebLead.last.name)
  end
end
