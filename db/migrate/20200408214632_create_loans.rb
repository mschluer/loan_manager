# frozen_string_literal: true

# Creates the first version of the loans table
class CreateLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :loans do |t|
      t.string :name
      t.float :total_amount
      t.date :date
      t.text :description
      t.integer :person_id

      t.timestamps
    end
  end
end
