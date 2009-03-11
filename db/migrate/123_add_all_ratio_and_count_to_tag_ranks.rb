class AddAllRatioAndCountToTagRanks < ActiveRecord::Migration
  def self.up
    add_column :tag_ranks, :global_ratio, :integer, :default => 0
    add_column :tag_ranks, :global_count, :integer, :default => 0
  end

  def self.down
    remove_column :tag_ranks, :global_ratio
    remove_column :tag_ranks, :global_count
  end
end
