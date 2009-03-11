class CreateActivitiesForDareResponses < ActiveRecord::Migration
  def self.up
    for dare_response in DareResponse.find(:all)
      activity = ActivityCreatedDareResponse.create_for(dare_response)
      activity.update_attribute(:created_at, dare_response.created_on)
    end
  end

  def self.down
  end
end
