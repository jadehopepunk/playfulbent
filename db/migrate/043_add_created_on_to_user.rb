class AddCreatedOnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :created_on, :datetime
  end

  def self.down
    remove_column :users, :created_on
  end
end
