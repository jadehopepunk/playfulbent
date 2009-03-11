class ChangeChapterPreferencesToPageVersionFollowers < ActiveRecord::Migration
  def self.up
    rename_table :chapter_preferences, :page_version_followers
    rename_column :page_version_followers, :story_fragment_id, :page_version_id
  end

  def self.down
    rename_column :page_version_followers, :page_version_id, :story_fragment_id
    rename_table :page_version_followers, :chapter_preferences
  end
end
