module SlotsHelper
  def slot_color(event)
    color_tag = event.settings["color_tag"]

    return color_tag  if color_tag.present?
    return "gray"     if event.blocked? && event.past?
    return "red"      if event.blocked?
    return "yellow"   if event.past? && event&.payment&.pending?
    return "green"
  end
end
