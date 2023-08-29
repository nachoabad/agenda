require "application_system_test_case"

class RegistrationsTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "should register a new user" do
    visit service_slots_path(@service)
    assert_text "Tienes que iniciar sesión o registrarte para poder continuar."
    
    click_on "Registrarse"
    assert_selector "h1", text: "Registrarse"

    fill_in "Email", with: "new_user@mail.com"
    fill_in "Clave", with: 123456
    fill_in "Confirmación de la clave", with: 123456
    fill_in "Nombre y Apellido", with: "New User"
    fill_in "Teléfono", with: "+34123456789"
    select "(GMT+01:00) Madrid", from: "Zona horario" 
    click_on "Registrarse"

    assert_text "Bienvenido. Tu cuenta fue creada."
    assert_selector "h1", text: @service.name
    assert_text "Hora #{User.last.time_zone}" 
  end
end
