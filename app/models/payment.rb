class Payment < ApplicationRecord
  validates :payment_amount, presence: true
  validates :date, presence: true

  belongs_to :loan
end
