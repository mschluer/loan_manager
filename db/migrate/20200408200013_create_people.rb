# frozen_string_literal: true

# Creates the first version of the people table
class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
