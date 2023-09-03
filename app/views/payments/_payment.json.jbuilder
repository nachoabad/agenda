json.extract! payment, :id, :status, :date, :amount, :reference, :event_id, :comments, :created_at, :updated_at
json.url payment_url(payment, format: :json)
