class AddStripShowIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :strip_show_id, :integer
  end

  def self.down
    remove_column :activities, :strip_show_id
  end
end
