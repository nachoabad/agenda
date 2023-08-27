require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
    @user    = users(:user1)
  end

  test "should login a user" do
    visit service_slots_path(@service)
    assert_text "Tienes que iniciar sesión o registrarte para poder continuar."
    
    assert_selector "h1", text: "Ingresar"

    fill_in "Email", with: "user1@mail.com"
    fill_in "Clave", with: "useruser"
    click_on "Ingresar"

    assert_text "Sesión iniciada."
    assert_selector "h1", text: @service.name
    assert_text "Hora #{@user.time_zone}" 
  end
end
