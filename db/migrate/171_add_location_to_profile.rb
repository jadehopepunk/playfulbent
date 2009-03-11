class AddLocationToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :location_id, :integer
  end

  def self.down
    remove_column :profiles, :location_id
  end
end
