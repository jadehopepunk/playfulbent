class AddRatiosToTagRanks < ActiveRecord::Migration
  def self.up
    add_column :tag_ranks, :story_ratio, :integer
    add_column :tag_ranks, :profile_ratio, :integer
  end

  def self.down
    remove_column :tag_ranks, :story_ratio
    remove_column :tag_ranks, :profile_ratio
  end
end
