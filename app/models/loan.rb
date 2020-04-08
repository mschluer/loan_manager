class Loan < ApplicationRecord
  validates :name, presence: true
  validates :total_amount, presence: true
  validates :date, presence: true

  belongs_to :person
end
