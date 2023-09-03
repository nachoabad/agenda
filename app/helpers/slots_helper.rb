module SlotsHelper
  def slot_color(event)
    return "gray"   if event.blocked? && event.past?
    return "red"    if event.blocked?
    return "yellow" if event.past? && event.payment.pending?
    return "green"
  end
end
