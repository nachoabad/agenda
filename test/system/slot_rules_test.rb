require "application_system_test_case"

class SlotRulesTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "admin can activate and inactivate a slot rule" do
    sign_in users(:admin1)
    visit service_slot_rules_url(@service)
    assert_selector "h1", text: "Horarios"

    click_on "08:00"
    click_on "Inactivar"
    page.driver.browser.switch_to.alert.accept
    assert page.has_css?('.bg-red-100', text: "8:00")

    click_on "08:00"
    click_on "Activar"
    page.driver.browser.switch_to.alert.accept
    assert page.has_css?('.bg-gray-100', text: "8:00")
  end

  test "inactive slot rules are not shown to users" do
    sign_in users(:admin1)
    visit service_slots_path(@service)
    assert_text "8:00am"

    visit service_slot_rules_url(@service)
    click_on "08:00"
    click_on "Inactivar"
    page.driver.browser.switch_to.alert.accept

    visit service_slots_path(@service)
    assert_no_text "8:00am"

    click_on "→"
    assert_no_text "8:00am"
  end

  test "inactive slot rules with an event are shown to users" do
    sign_in users(:admin1)
    visit service_slots_path(@service)
    click_on "8:00am"
    click_on "Crear cita"
    fill_in "Nombre y Apellido", with: "User on event name"
    fill_in "Comentario", with: "Mi comentario"
    select  "Service B", from: "Servicio"
    click_on "Crear cita"

    visit service_slot_rules_url(@service)
    click_on "08:00"
    click_on "Inactivar"
    page.driver.browser.switch_to.alert.accept

    visit service_slots_path(@service)
    assert_text "User On Event Name"
    assert_text "8:00am"

    click_on "→"
    assert_no_text "8:00am"
  end
end
