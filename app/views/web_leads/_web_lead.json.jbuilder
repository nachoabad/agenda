json.extract! web_lead, :id, :name, :email, :phone, :message, :created_at, :updated_at
json.url web_lead_url(web_lead, format: :json)
