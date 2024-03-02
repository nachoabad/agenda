module SlotRulesHelper
  def slot_rule_color(slot_rule)
    return "red" if slot_rule.inactive?
    return "gray"
  end
end
