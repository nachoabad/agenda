require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "user can create and cancel an event on standard time" do
     # standard time
    travel_to Time.new(1.year.from_now.year, 12, 01, 01, 04, 44)
    sign_in users(:user1)

    visit service_slots_path(@service)

    click_on "10:00am"
    assert_text "10:00am"
    
    fill_in "Comentario", with: "Mi comentario"
    select  "Service B", from: "Servicio"
    click_on "Reservar esta cita"
    assert_text "Cita creada éxitosamente"

    click_on "Regresar"
    assert_no_text "10:00am"

    click_link "main_menu"
    click_on "Mis citas"
    assert_text "Mi comentario"
    assert_text "10:00am"
    assert_text "Service B"

    click_on "Cancelar esta cita"
    page.driver.browser.switch_to.alert.accept
    assert_text "Cita anulada éxitosamente"
    assert_text "10:00am"

    click_link "main_menu"
    click_on "Mis citas"
    assert_no_text "10:00am"
  end

  test "admin can see and cancel an user event on standard time" do
    # standard time
    travel_to Time.new(1.year.from_now.year, 12, 01, 01, 04, 44)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    click_link "main_menu"
    click_on "Mis citas"
    assert_no_text "Cancelar esta cita"

    sign_out(:admin1)
    sign_in users(:user1)
    visit service_slots_path(@service)

    click_on "10:00am"
    assert_text "10:00am"
    
    select  "Service B", from: "Servicio"
    click_on "Reservar esta cita"
    assert_text "Cita creada éxitosamente"

    click_on "Regresar"
    assert_no_text "10:00am"

    click_link "main_menu"
    click_on "Mis citas"
    assert_text "10:00am"

    sign_out(:user1)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    assert page.has_css?('.bg-green-100', text: users(:user1).name)
    assert page.has_css?('.bg-gray-100', text: "8:00am")
    assert page.has_css?('.bg-green-100', text: "3:00pm")

    click_link "main_menu"
    click_on "Mis citas"
    assert_text "3:00pm"
    assert_text users(:user1).name

    click_on "Cancelar esta cita"
    page.driver.browser.switch_to.alert.accept
    assert_text "Cita anulada éxitosamente"

    assert page.has_css?('.bg-gray-100', text: "8:00am")
    assert page.has_css?('.bg-gray-100', text: "3:00pm")
    
    sign_out(:admin1)
    sign_in users(:user1)
    visit service_slots_path(@service)

    assert_text "10:00am"
    click_link "main_menu"
    click_on "Mis citas"
    assert_no_text "10:00am"
  end

  test "admin can block and unblock a slot on standard time" do
    # standard time
    travel_to Time.new(1.year.from_now.year, 12, 01, 01, 04, 44)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    click_on "8:00am"
    click_on "Bloquear esta cita"
    assert_text "Cita bloqueada éxitosamente"
    click_on "Regresar"

    assert page.has_css?('.bg-red-100', text: "8:00am")
    assert page.has_css?('.bg-gray-100', text: "3:00pm")

    sign_out(:admin1)
    sign_in users(:user1)
    visit service_slots_path(@service)

    assert_no_text "3:00am"

    sign_out(:user1)
    sign_in users(:admin1)

    click_link "main_menu"
    click_on "Mis citas"
    assert_no_text "CITA BLOQUEADA"
    click_link "main_menu"
    click_on "Regresar"

    click_on "8:00am"
    assert_text "CITA BLOQUEADA"
    click_on "Desbloquear esta cita"
    page.driver.browser.switch_to.alert.accept
    assert_text "Cita desbloqueada éxitosamente"

    assert page.has_css?('.bg-gray-100', text: "8:00am")
    assert page.has_css?('.bg-gray-100', text: "3:00pm")
  end

  test "admin can create an event with no user" do
    # standard time
    travel_to Time.new(1.year.from_now.year, 12, 01, 01, 04, 44)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    click_on "8:00am"
    click_on "Crear cita"
    fill_in "Nombre y Apellido", with: "User on event name"
    fill_in "Comentario", with: "Mi comentario"
    select  "Service B", from: "Servicio"

    click_on "Crear cita"

    assert_text "Cita creada éxitosamente"
    assert_text "User On Event Name"
    assert_text "Mi comentario"
    assert_text "Service B"
  end

  test "admin can create an event registering a new user" do
    # standard time
    travel_to Time.new(1.year.from_now.year, 12, 01, 01, 04, 44)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    click_on "8:00am"
    click_on "Crear cita"
    fill_in "Comentario", with: "Mi comentario"
    select  "Service B", from: "Servicio"
    fill_in "Email", with: "new_user@mail.com"
    fill_in "Nombre y Apellido", with: "New User"
    fill_in "Teléfono", with: "+34123456789"
    select "(GMT+01:00) Madrid", from: "Zona horario"
    click_on "Crear cita"

    assert_text "Cita creada éxitosamente"
    assert_text "New User"
    assert_text "new_user@mail.com"
    assert_text "+34123456789"
    assert_text "Mi comentario"
    assert_text "Service B"
  end
end
