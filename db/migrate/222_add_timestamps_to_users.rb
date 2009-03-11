class AddTimestampsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :updated_at, :datetime
    add_column :users, :last_logged_in_at, :datetime

    execute "UPDATE users SET updated_at = created_on"
  end

  def self.down
    remove_column :users, :last_logged_in_at
    remove_column :users, :updated_at
  end
end
