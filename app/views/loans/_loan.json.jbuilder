json.extract! loan, :id, :name, :total_amount, :date, :description, :created_at, :updated_at
json.url loan_url(loan, format: :json)
