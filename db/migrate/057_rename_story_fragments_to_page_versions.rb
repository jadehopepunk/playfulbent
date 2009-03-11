class RenameStoryFragmentsToPageVersions < ActiveRecord::Migration
  def self.up
    rename_table :story_fragments, :page_versions
  end

  def self.down
    rename_table :page_versions, :story_fragments
  end
end
