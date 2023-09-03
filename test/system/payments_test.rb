require "application_system_test_case"

class PaymentsTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "user can create an event and report payment" do
    travel_to Time.new(Time.current.year + 1, 12, 01, 01, 04, 44)
    sign_in users(:user1)

    visit service_slots_path(@service)

    click_on "3:00am"
    click_on "Reservar esta cita"
    click_on "Reportar pago"

    fill_in "Fecha de pago", with: "30/01/2023"
    fill_in "Monto", with: "50"
    select "bs", from: "payment[currency]"
    fill_in "Referencia de pago", with: "Zelle 123"
    click_on "Reportar pago"

    assert_text "Pago éxitosamente reportado"
  end

  test "user can see a pending payments and report it" do
    travel_to Time.new(Time.current.year + 1, 12, 01, 01, 04, 44)
    sign_in users(:user1)

    visit service_slots_path(@service)

    click_on "Mis citas"
    click_on "Reportar pago"

    fill_in "Fecha de pago", with: "30/01/2023"
    fill_in "Monto", with: "50"
    select "bs", from: "payment[currency]"
    fill_in "Referencia de pago", with: "Zelle 123"
    click_on "Reportar pago"

    assert_text "Pago éxitosamente reportado"

    click_on "Regresar"
    assert_no_text "Reportar pago"
  end
  
  test "admin can see a pending payment, report it and confirm it" do
    sign_in users(:admin1)

    visit service_slots_path(@service)

    click_on "Mis citas"
    click_on "Ver pagos"

    assert page.has_css?('.bg-yellow-100', text: "Pago pendiente")
    click_on "Pago pendiente"

    fill_in "Fecha de pago", with: "30/01/2023"
    fill_in "Monto", with: "50"
    select "bs", from: "payment[currency]"
    fill_in "Referencia de pago", with: "Zelle 123"
    click_on "Confirmar pago"

    assert_text "Pago éxitosamente confirmado"

    click_on "Regresar"
    click_on "Ver pagos"

    assert_no_text "Pago pendiente"
    assert_no_text "Confirmar pago"
  end
end
