class Loan < ApplicationRecord
  validates :name, presence: true
  validates :total_amount, presence: true
  validates :date, presence: true

  belongs_to :person
  has_many :payments

  def balance
    result = total_amount

    payments.each do |payment|
      result += payment.payment_amount
    end

    result
  end

  def days_open
    if balance != 0
      DateTime.now.mjd - self.date.mjd
    else
      self.payments.last.date.mjd - self.date.mjd
    end
  end
end
