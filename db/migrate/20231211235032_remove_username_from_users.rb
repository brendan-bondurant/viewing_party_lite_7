# frozen_string_literal: true

# This migration removes the 'username' column from the 'users' table.
class RemoveUsernameFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :username
  end
end
