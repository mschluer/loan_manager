json.extract! payment, :id, :payment_amount, :date, :description, :created_at, :updated_at
json.url payment_url(payment, format: :json)
