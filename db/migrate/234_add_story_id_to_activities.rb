class AddStoryIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :story_id, :integer
  end

  def self.down
    remove_column :activities, :story_id
  end
end
