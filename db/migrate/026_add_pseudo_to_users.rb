class AddPseudoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_pseudo, :boolean, :default => false
  end

  def self.down
    remove_column :users, :is_pseudo
  end
end
