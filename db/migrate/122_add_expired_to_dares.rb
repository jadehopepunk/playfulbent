class AddExpiredToDares < ActiveRecord::Migration
  def self.up
    add_column :dares, :expired, :boolean, :default => false
  end

  def self.down
    remove_column :dares, :expired
  end
end
