class Slot
  include ActiveModel::Model

  attr_reader :rule, :event, :service_time_zone_date

  def initialize(user_time_zone_date_time, rule, event, service_time_zone_date)
    @user_time_zone_date_time = user_time_zone_date_time
    @rule = rule
    @event = event
    @service_time_zone_date = service_time_zone_date
  end

  def time
    @user_time_zone_date_time.strftime('%l:%M%P')
  end

  def date
    @user_time_zone_date_time.to_date
  end
end