class ScheduledPayment < ApplicationRecord
  validates :payment_amount, presence: true
  validates :date, presence: true

  belongs_to :loan

  def due_string
    if DateTime.now < date
      "In #{date.mjd - DateTime.now.mjd} Days"
    else
      "Since #{DateTime.now.mjd - date.mjd} Days"
    end
  end
end
