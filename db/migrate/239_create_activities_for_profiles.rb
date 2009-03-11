class CreateActivitiesForProfiles < ActiveRecord::Migration
  def self.up
    for profile in Profile.find(:all)
      activity = ActivityCreatedProfile.create_for(profile)
      activity.update_attribute(:created_at, profile.created_on)
    end
  end

  def self.down
  end
end
