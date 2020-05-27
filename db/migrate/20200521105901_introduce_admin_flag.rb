# frozen_string_literal: true

# Introduces the admin flag to the user
class IntroduceAdminFlag < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
