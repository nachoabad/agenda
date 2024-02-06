require "application_system_test_case"

class EventRulesTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "user can create and cancel a recurrent event on standard time" do
     # standard time
    travel_to Time.new(1.year.from_now.year, 12, 01, 01, 04, 44)
    sign_in users(:user1)

    visit service_slots_path(@service)

    click_on "3:00am"
    assert_text "3:00am"

    select  "Service B", from: "Servicio"
    click_on "Reservar este horario quincenal"
    assert_text "Cita Quincenal creada éxitosamente"

    click_on "Regresar"
    assert_text @service.name
    assert_no_text "3:00am"

    click_on "→"
    assert_text @service.name
    assert_text "3:00am"

    click_on "→"
    assert_text @service.name
    assert_no_text "3:00am"

    click_on "Mis citas"
    assert_text "Mis citas"

    click_on("Cancelar cita recurrente", :match => :first)
    page.driver.browser.switch_to.alert.accept
    assert_text "Citas recurrentes anuladas éxitosamente"
  end

  test "admin can see and cancel a recurrent user event on standard time" do
    # standard time
    travel_to Time.new(1.year.from_now.year, 12, 01, 01, 04, 44)
    sign_in users(:user1)

    visit service_slots_path(@service)

    click_on "3:00am"

    select  "Service B", from: "Servicio"
    click_on "Reservar este horario quincenal"
    assert_text "Cita Quincenal creada éxitosamente"

    sign_out(:user1)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    assert page.has_css?('.bg-green-100', text: "8:00am")
    click_on "→"
    assert page.has_css?('.bg-gray-100', text: "8:00am")
    click_on "→"
    assert page.has_css?('.bg-green-100', text: "8:00am")

    click_on "Mis citas"
    assert_text "Mis citas"

    click_on("Cancelar cita recurrente", :match => :first)
    page.driver.browser.switch_to.alert.accept
    assert_text "Citas recurrentes anuladas éxitosamente"
  end

  test "admin can create a recurrent user event for a new registered user on standard time" do
    # standard time
    travel_to Time.new(1.year.from_now.year, 12, 01, 01, 04, 44)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    click_on "8:00am"
    click_on "Crear cita"
    fill_in "Email", with: "new_user@mail.com"
    fill_in "Nombre y Apellido", with: "New Recurrent User"
    fill_in "Teléfono", with: "+34123456789"
    select "(GMT+01:00) Madrid", from: "Zona horario"
    select "Cita quincenal"
    select  "Service B", from: "Servicio"
    click_on "Crear cita"

    click_on "Regresar"

    assert page.has_css?('.bg-green-100', text: "New Recurrent User")
    assert page.has_css?('.bg-green-100', text: "8:00am")
    click_on "→"
    assert page.has_css?('.bg-gray-100', text: "8:00am")
    click_on "→"
    assert page.has_css?('.bg-green-100', text: "New Recurrent User")
    assert page.has_css?('.bg-green-100', text: "8:00am")
  end

  test "admin can create a recurrent user event for an already registered user on standard time" do
    # standard time
    travel_to Time.new(1.year.from_now.year, 12, 01, 01, 04, 44)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    click_on "8:00am"
    click_on "Crear cita"
    fill_in "Email", with: users(:user1).email
    fill_in "Nombre y Apellido", with: "New Recurrent User"
    fill_in "Teléfono", with: "+34123456789"
    select "(GMT+01:00) Madrid", from: "Zona horario"
    select "Cita quincenal"
    select  "Service B", from: "Servicio"
    click_on "Crear cita"

    click_on "Regresar"

    assert page.has_css?('.bg-green-100', text: users(:user1).name)
    assert page.has_css?('.bg-green-100', text: "8:00am")
    click_on "→"
    assert page.has_css?('.bg-gray-100', text: "8:00am")
    click_on "→"
    assert page.has_css?('.bg-green-100', text: users(:user1).name)
    assert page.has_css?('.bg-green-100', text: "8:00am")
  end

  test "admin can create a recurrent user event for a none registered user on standard time" do
    # standard time
    travel_to Time.new(1.year.from_now.year, 12, 01, 01, 04, 44)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    click_on "8:00am"
    click_on "Crear cita"
    fill_in "Nombre y Apellido", with: "New User Event Name"
    select "Cita semanal"
    select  "Service B", from: "Servicio"
    click_on "Crear cita"

    click_on "Regresar"

    assert page.has_css?('.bg-green-100', text: "New User Event Name")
    assert page.has_css?('.bg-green-100', text: "8:00am")
    click_on "→"
    assert page.has_css?('.bg-green-100', text: "New User Event Name")
    assert page.has_css?('.bg-green-100', text: "8:00am")
  end
end
