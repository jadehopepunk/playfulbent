class RemovePseudoUserColumn < ActiveRecord::Migration
  def self.up
    remove_column :users, :is_pseudo
  end

  def self.down
    add_column :users, :is_pseudo, :integer, :default => 0
  end
end
