# frozen_string_literal: true

class Person < ApplicationRecord
  belongs_to :user
  has_many :loans

  validates :user_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def id_with_full_name
    "##{id} #{full_name}"
  end

  def average_loan_duration_days
    if (loans_size = loans.size).zero?
      -1
    else
      total = 0
      loans.each do |loan|
        total += loan.days_open
      end
      total / loans_size
    end
  end
end
