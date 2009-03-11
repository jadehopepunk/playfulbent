class RemoveTitleFromStoryFragments < ActiveRecord::Migration
  def self.up
    remove_column(:story_fragments, :title)
  end

  def self.down
    add_column(:story_fragments, :title, :string)
    StoryFragment.find_all.each do |fragment|
      fragment.title = fragment.story.title
      fragment.update
    end
  end
end
