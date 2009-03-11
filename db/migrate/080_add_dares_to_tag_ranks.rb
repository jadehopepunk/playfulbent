class AddDaresToTagRanks < ActiveRecord::Migration
  def self.up
    add_column :tag_ranks, :dare_count, :integer, :default => 0
    add_column :tag_ranks, :dare_ratio, :integer, :default => 0
    add_index :tag_ranks, :dare_count
  end

  def self.down
    remove_column :tag_ranks, :dare_ratio
    remove_column :tag_ranks, :dare_count
    remove_index :tag_ranks, :dare_count
  end
end
