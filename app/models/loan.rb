class Loan < ApplicationRecord
  validates :name, presence: true
  validates :total_amount, presence: true
  validates :date, presence: true

  belongs_to :person
  has_many :payments

  def remaining_amount
    result = total_amount

    payments.each do |payment|
      result -= payment.payment_amount
    end

    result
  end
end
