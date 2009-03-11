class AddMapFieldsToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :map_lat, :float
    add_column :groups, :map_long, :float
    add_column :groups, :map_zoom, :integer
    
    execute "UPDATE groups SET map_lat = -41.212100, map_long = 172.463400, map_zoom = 5"
  end

  def self.down
    remove_column :groups, :map_lat
    remove_column :groups, :map_long
    remove_column :groups, :map_zoom
  end
end
