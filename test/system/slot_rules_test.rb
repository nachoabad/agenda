require "application_system_test_case"

class SlotRulesTest < ApplicationSystemTestCase
  setup do
    @slot_rule = slot_rules(:one)
  end

  # test "visiting the index" do
  #   visit slot_rules_url
  #   assert_selector "h1", text: "Slot rules"
  # end

  # test "should create slot rule" do
  #   visit slot_rules_url
  #   click_on "New slot rule"

  #   fill_in "Time", with: @slot_rule.time
  #   fill_in "User", with: @slot_rule.user_id
  #   fill_in "wday", with: @slot_rule.wday
  #   click_on "Create Slot rule"

  #   assert_text "Slot rule was successfully created"
  #   click_on "Back"
  # end

  # test "should update Slot rule" do
  #   visit slot_rule_url(@slot_rule)
  #   click_on "Edit this slot rule", match: :first

  #   fill_in "Time", with: @slot_rule.time
  #   fill_in "User", with: @slot_rule.user_id
  #   fill_in "wday", with: @slot_rule.wday
  #   click_on "Update Slot rule"

  #   assert_text "Slot rule was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Slot rule" do
  #   visit slot_rule_url(@slot_rule)
  #   click_on "Destroy this slot rule", match: :first

  #   assert_text "Slot rule was successfully destroyed"
  # end
end
