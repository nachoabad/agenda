require "application_system_test_case"

class TimeZonesTest < ApplicationSystemTestCase
  setup do
    sign_in users(:user1)
    @service = services(:one)
  end

  test "should set new user time zone on standard time" do
    # standard time
    travel_to Time.new(Time.current.year, 12, 01, 01, 04, 44)
    visit service_slots_path(@service)
    assert_text "3:00"

    click_on "cambiar"
    
    select "(GMT+01:00) Madrid", from: :time_zone
    click_on "Guardar"

    assert_text "Zona horario actulizada éxitosamente"
    assert_text "Madrid"
    assert_text "8:00"
  end

  test "should set new user time zone on daylight time" do
    # daylight time
    travel_to Time.new(Time.current.year, 06, 01, 01, 04, 44)
    visit service_slots_path(@service)
    assert_text "2:00"

    click_on "cambiar"
    
    select "(GMT+01:00) Madrid", from: :time_zone
    click_on "Guardar"

    assert_text "Zona horario actulizada éxitosamente"
    assert_text "Madrid"
    assert_text "8:00"
  end
end
