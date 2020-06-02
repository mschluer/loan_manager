# frozen_string_literal: true

class ScheduledPayment < ApplicationRecord
  validates :payment_amount, presence: true
  validates :date, presence: true

  belongs_to :loan

  def due_string
    if overdue?
      "Since #{ActionController::Base.helpers.pluralize DateTime.now.mjd - date.mjd, 'Day'}"
    else
      "In #{ActionController::Base.helpers.pluralize date.mjd - DateTime.now.mjd, 'Day'}"
    end
  end

  def overdue?
    DateTime.now.mjd > date.mjd
  end
end
