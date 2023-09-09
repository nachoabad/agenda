require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "user can create and cancel a recurrent event on standard time" do
     # standard time
    travel_to Time.new(Time.current.year, 12, 01, 01, 04, 44)
    sign_in users(:user1)

    visit service_slots_path(@service)

    click_on "3:00am"
    assert_text "3:00am"
    
    click_on "Reservar este horario quincenal"
    assert_text "Cita Quincenal creada éxitosamente"

    click_on "Regresar"
    assert_text @service.name
    assert_no_text "3:00am"

    click_on ">"
    assert_text @service.name
    assert_text "3:00am"

    click_on ">"
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
    travel_to Time.new(Time.current.year, 12, 01, 01, 04, 44)
    sign_in users(:user1)

    visit service_slots_path(@service)

    click_on "3:00am"
    
    click_on "Reservar este horario quincenal"
    assert_text "Cita Quincenal creada éxitosamente"

    sign_out(:user1)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    assert page.has_css?('.bg-green-100', text: "8:00am")
    click_on ">"
    assert page.has_css?('.bg-gray-100', text: "8:00am")
    click_on ">"
    assert page.has_css?('.bg-green-100', text: "8:00am")
    
    click_on "Mis citas"
    assert_text "Mis citas"

    click_on("Cancelar cita recurrente", :match => :first)
    page.driver.browser.switch_to.alert.accept
    assert_text "Citas recurrentes anuladas éxitosamente"
  end
end
