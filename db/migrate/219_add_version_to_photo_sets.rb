class AddVersionToPhotoSets < ActiveRecord::Migration
  def self.up
    add_column :photo_sets, :version, :integer, :default => 1
  end

  def self.down
    remove_column :photo_sets, :version
  end
end
