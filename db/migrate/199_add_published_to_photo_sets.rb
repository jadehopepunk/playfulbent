class AddPublishedToPhotoSets < ActiveRecord::Migration
  def self.up
    add_column :photo_sets, :published, :boolean, :default => false
  end

  def self.down
    remove_column :photo_sets, :published
  end
end
