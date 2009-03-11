class SetDefaultsForTagRanks < ActiveRecord::Migration
  def self.up
    execute "UPDATE tag_ranks SET story_count = 0 WHERE story_count IS NULL"
    execute "UPDATE tag_ranks SET story_ratio = 0 WHERE story_ratio IS NULL"
    execute "UPDATE tag_ranks SET profile_count = 0 WHERE profile_count IS NULL"
    execute "UPDATE tag_ranks SET profile_ratio = 0 WHERE profile_ratio IS NULL"
    
    change_column :tag_ranks, :story_count, :integer, :default => 0
    change_column :tag_ranks, :story_ratio, :integer, :default => 0
    change_column :tag_ranks, :profile_count, :integer, :default => 0
    change_column :tag_ranks, :profile_ratio, :integer, :default => 0
  end

  def self.down
  end
end
