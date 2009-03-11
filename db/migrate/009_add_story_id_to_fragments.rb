class AddStoryIdToFragments < ActiveRecord::Migration
  def self.up
    add_column(:story_fragments, :story_id, :integer)
  end

  def self.down
    remove_column(:story_fragments, :story_id)
  end
end
