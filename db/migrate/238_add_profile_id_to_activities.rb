class AddProfileIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :profile_id, :integer
  end

  def self.down
    remove_column :activities, :profile_id
  end
end
