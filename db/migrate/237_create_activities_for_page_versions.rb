class CreateActivitiesForPageVersions < ActiveRecord::Migration
  def self.up
    for page in PageVersion.find(:all, :conditions => "parent_id IS NOT NULL")
      activity = ActivityContinuedStory.create_for(page)
      activity.update_attribute(:created_at, page.created_on)
    end
  end

  def self.down
  end
end
