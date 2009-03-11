class AddTitleToGalleryPhotos < ActiveRecord::Migration
  def self.up
    add_column :gallery_photos, :title, :string, :default => 'Untitled'
  end

  def self.down
    remove_column :gallery_photos, :title
  end
end
