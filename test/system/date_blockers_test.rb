require "application_system_test_case"

class TimeZonesTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "admin can block a date" do
    sign_in users(:admin1)

    visit service_slots_path(@service)
    assert_not page.has_css?('.bg-red-100', text: "8:00am")

    click_link "date_blocker"
    assert_text "Lunes"

    click_on "Bloquear fecha"
    page.driver.browser.switch_to.alert.accept
    assert_text 'Fecha bloqueada éxitosamente'
    assert page.has_css?('.bg-red-100', text: "8:00am")

    click_link "date_blocker"

    click_on "Desbloquear fecha"
    page.driver.browser.switch_to.alert.accept
    assert_text 'Fecha desbloqueada éxitosamente'
    assert_not page.has_css?('.bg-red-100', text: "8:00am")
  end
end
