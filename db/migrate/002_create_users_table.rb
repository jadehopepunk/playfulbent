class CreateUsersTable < ActiveRecord::Migration
  def self.up
      create_table :users do |table|
        table.column(:login,  :string, :limit => 80)
        table.column(:password, :string, :limit => 40)
      end
    end

  def self.down
      drop_table :users
  end
end
