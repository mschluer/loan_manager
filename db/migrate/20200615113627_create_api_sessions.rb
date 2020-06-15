# frozen_string_literal: true

class CreateApiSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :api_sessions do |t|
      t.string :key
      t.date :expiry_date
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
