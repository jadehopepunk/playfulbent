class AddVersionToGalleryPhotos < ActiveRecord::Migration
  def self.up
    add_column :gallery_photos, :version, :integer, :default => 1
  end

  def self.down
    remove_column :gallery_photos, :version
  end
end
