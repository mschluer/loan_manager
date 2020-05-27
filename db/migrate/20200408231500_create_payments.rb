# frozen_string_literal: true

# Creates the first version of the payments table
class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.float :payment_amount
      t.date :date
      t.text :description
      t.integer :loan_id

      t.timestamps
    end
  end
end
