namespace :event_rules_future_events do
  desc "Creates next future event rules events"

  task :create => [ :environment ] do
    EventRule.active.find_each do |event_rule|
      if events = Event.where(
          user: event_rule.user,
          slot_rule: event_rule.slot_rule,
          date: Date.today..
        ).presence && events.size < 10

        event_rule.create_events_from(events.order(:date).last)
      end
    end
  end
  # bin/rake event_rules_future_events:create
end
