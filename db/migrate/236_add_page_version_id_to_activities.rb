class AddPageVersionIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :page_version_id, :integer
  end

  def self.down
    remove_column :activities, :page_version_id
  end
end
