class AddDareResponseIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :dare_response_id, :integer
  end

  def self.down
    remove_column :activities, :dare_response_id
  end
end
