require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "user can create and cancel an event on standard time" do
     # standard time
    travel_to Time.new(Time.current.year, 12, 01, 01, 04, 44)
    sign_in users(:user1)

    visit service_slots_path(@service)

    click_on "3:00am"
    assert_text "3:00am"
    
    click_on "Reservar cita"
    assert_text "Cita creada éxitosamente"

    click_on "Regresar"
    assert_no_text "3:00am"

    click_on "Mis citas"
    assert_text "3:00am"

    click_on "Cancelar esta cita"
    assert_text "Cita anulada éxitosamente"
    assert_text "3:00am"

    click_on "Mis citas"
    assert_no_text "3:00am"
  end

  test "admin can see and cancel an user event on standard time" do
    # standard time
    travel_to Time.new(Time.current.year, 12, 01, 01, 04, 44)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    click_on "Mis citas"
    assert_no_text "Cancelar esta cita"

    sign_out(:admin1)
    sign_in users(:user1)
    visit service_slots_path(@service)

    click_on "3:00am"
    assert_text "3:00am"
    
    click_on "Reservar cita"
    assert_text "Cita creada éxitosamente"

    click_on "Regresar"
    assert_no_text "3:00am"

    click_on "Mis citas"
    assert_text "3:00am"

    sign_out(:user1)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    assert page.has_css?('.bg-green-50', text: "8:00am")
    assert page.has_css?('.bg-gray-100', text: "3:00pm")

    click_on "Mis citas"
    assert_text "8:00am"
    assert_text users(:user1).name

    click_on "Cancelar esta cita"
    assert_text "Cita anulada éxitosamente"

    assert page.has_css?('.bg-gray-100', text: "8:00am")
    assert page.has_css?('.bg-gray-100', text: "3:00pm")
    
    sign_out(:admin1)
    sign_in users(:user1)
    visit service_slots_path(@service)

    assert_text "3:00am"
    click_on "Mis citas"
    assert_no_text "3:00am"
  end

  test "admin can block and unblock a slot on standard time" do
    # standard time
    travel_to Time.new(Time.current.year, 12, 01, 01, 04, 44)
    sign_in users(:admin1)
    visit service_slots_path(@service)

    click_on "8:00am"
    click_on "Bloquear esta cita"
    assert_text "Cita bloqueada éxitosamente"
    click_on "Regresar"

    assert page.has_css?('.bg-red-50', text: "8:00am")
    assert page.has_css?('.bg-gray-100', text: "3:00pm")

    sign_out(:admin1)
    sign_in users(:user1)
    visit service_slots_path(@service)

    assert_no_text "3:00am"

    sign_out(:user1)
    sign_in users(:admin1)

    click_on "Mis citas"
    assert_text "CITA BLOQUEADA"
    click_on "Desbloquear esta cita"
    assert_text "Cita desbloqueada éxitosamente"

    assert page.has_css?('.bg-gray-100', text: "8:00am")
    assert page.has_css?('.bg-gray-100', text: "3:00pm")
  end
end
