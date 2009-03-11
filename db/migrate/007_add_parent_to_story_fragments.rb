class AddParentToStoryFragments < ActiveRecord::Migration
  def self.up
    add_column(:story_fragments, :parent_id, :integer)
  end

  def self.down
    remove_column(:story_fragments, :parent_id)
  end
end
