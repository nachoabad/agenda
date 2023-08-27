require "test_helper"

class SlotRulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @slot_rule = slot_rules(:one)
  end

  # test "should get index" do
  #   get slot_rules_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_slot_rule_url
  #   assert_response :success
  # end

  # test "should create slot_rule" do
  #   assert_difference("SlotRule.count") do
  #     post slot_rules_url, params: { slot_rule: { time: @slot_rule.time, user_id: @slot_rule.user_id, wday: @slot_rule.wday } }
  #   end

  #   assert_redirected_to slot_rule_url(SlotRule.last)
  # end

  # test "should show slot_rule" do
  #   get slot_rule_url(@slot_rule)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_slot_rule_url(@slot_rule)
  #   assert_response :success
  # end

  # test "should update slot_rule" do
  #   patch slot_rule_url(@slot_rule), params: { slot_rule: { time: @slot_rule.time, user_id: @slot_rule.user_id, wday: @slot_rule.wday } }
  #   assert_redirected_to slot_rule_url(@slot_rule)
  # end

  # test "should destroy slot_rule" do
  #   assert_difference("SlotRule.count", -1) do
  #     delete slot_rule_url(@slot_rule)
  #   end

  #   assert_redirected_to slot_rules_url
  # end
end
