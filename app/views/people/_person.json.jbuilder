# frozen_string_literal: true

json.extract! person, :id, :first_name, :last_name, :phone_number, :created_at, :updated_at
json.url person_url(person, format: :json)
