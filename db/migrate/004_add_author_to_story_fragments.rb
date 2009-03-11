class AddAuthorToStoryFragments < ActiveRecord::Migration
  def self.up
    add_column(:story_fragments, :author_id, :integer)
  end

  def self.down
    remove_column(:story_fragments, :author_id)
  end
end
