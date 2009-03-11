class RenamePasswordToHashedPassword < ActiveRecord::Migration
  def self.up
    add_column :users, :hashed_password, :string
    execute "UPDATE users SET hashed_password = password"
    remove_column :users, :password
  end

  def self.down
    remove_column :users, :hashed_password
  end
end
