class CreateScheduledPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :scheduled_payments do |t|
      t.float :payment_amount
      t.date :date
      t.text :description
      t.integer :loan_id

      t.timestamps
    end
  end
end
