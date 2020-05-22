class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  has_many :people, foreign_key: 'user_id', class_name: 'Person', dependent: :destroy

  def switch_admin_access!
    self.admin = !self.admin
    save!
  end
end
