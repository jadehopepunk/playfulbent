class AddRespondedToDares < ActiveRecord::Migration
  def self.up
    add_column :dares, :responded_to, :boolean, :default => false
  end

  def self.down
    remove_column :dares, :responded_to
  end
end
