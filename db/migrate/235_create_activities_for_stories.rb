class CreateActivitiesForStories < ActiveRecord::Migration
  def self.up
    for story in Story.find(:all)
      activity = ActivityCreatedStory.create_for(story)
      activity.update_attribute(:created_at, story.created_on || 6.months.ago)
    end
  end

  def self.down
    ActivityCreatedStory.destroy_all
  end
end
