class AddGenderIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :gender_id, :integer    
  end

  def self.down
    remove_column :users, :gender_id
  end
end
