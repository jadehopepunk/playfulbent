class CreateActivitiesForStripShows < ActiveRecord::Migration
  def self.up
    for strip_show in StripShow.find(:all)
      activity = ActivityCreatedStripShow.create_for(strip_show)
      activity.update_attribute(:created_at, strip_show.published_at)
    end
  end

  def self.down
  end
end
