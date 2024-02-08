require "application_system_test_case"

class TimeZonesTest < ApplicationSystemTestCase
  setup do
    @service = services(:one)
  end

  test "user cannot block a date" do
    sign_in users(:user1)
    visit service_slots_path(@service)
    assert_text "3:00"
    assert_no_text "bloquear"
  end

  test "admin can block a date" do
    sign_in users(:admin1)

    visit service_slots_path(@service)
    assert_not page.has_css?('.bg-red-100', text: "8:00am")

    click_on "bloquear"
    assert_text "Lunes"

    click_on "Bloquear fecha"
    page.driver.browser.switch_to.alert.accept
    assert_text 'Fecha bloqueada éxitosamente'
    assert page.has_css?('.bg-red-100', text: "8:00am")
  end
end
