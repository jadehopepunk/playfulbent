class CreateActivitiesForDares < ActiveRecord::Migration
  def self.up
    for dare in Dare.find(:all)
      activity = ActivityCreatedDare.create_for(dare)
      activity.update_attribute(:created_at, dare.created_on)
    end
  end

  def self.down
  end
end
