# frozen_string_literal: true

json.extract! scheduled_payment, :id, :payment_amount, :date, :description, :loan_id, :created_at, :updated_at
json.url scheduled_payment_url(scheduled_payment, format: :json)
