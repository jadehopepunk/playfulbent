class AddStoryIndexToPageVersions < ActiveRecord::Migration
  def self.up
    add_index :page_versions, :story_id
  end

  def self.down
    remove_index :page_versions, :story_id
  end
end
