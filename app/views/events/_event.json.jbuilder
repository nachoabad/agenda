json.extract! event, :id, :status, :user_id, :slot_rule_id, :created_at, :updated_at
json.url event_url(event, format: :json)
