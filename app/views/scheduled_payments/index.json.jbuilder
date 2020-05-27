# frozen_string_literal: true

json.array! @scheduled_payments, partial: 'scheduled_payments/scheduled_payment', as: :scheduled_payment
