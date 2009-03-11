class AddDareIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :dare_id, :integer
  end

  def self.down
    remove_column :activities, :dare_id
  end
end
