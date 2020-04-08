class Person < ApplicationRecord
  belongs_to :user
  has_many :loans

  def full_name
    "#{first_name} #{last_name}"
  end

  def id_with_full_name
    "##{id} #{full_name}"
  end
end
