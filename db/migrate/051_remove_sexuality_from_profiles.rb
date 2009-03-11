class RemoveSexualityFromProfiles < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :likes_boys
    remove_column :profiles, :likes_girls
  end

  def self.down
    add_column :profiles, :likes_boys, :boolean, :null => true
    add_column :profiles, :likes_girls, :boolean, :null => true
  end
end
