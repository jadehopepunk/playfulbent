class CreateAStoryForEachFragment < ActiveRecord::Migration
  def self.up
    StoryFragment.find_all.each do |fragment|
      story = Story.new
      story.title = fragment.title
      story.create

      fragment.story = story
      fragment.update
    end
  end

  def self.down
    execute "UPDATE story_fragments SET story_id = 0"
    Story.delete_all
  end
end
