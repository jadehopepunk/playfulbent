class AddTitleToStoryFragments < ActiveRecord::Migration
  def self.up
    add_column(:story_fragments, :title, :string)
  end

  def self.down
    remove_column(:story_fragments, :title)
  end
end
