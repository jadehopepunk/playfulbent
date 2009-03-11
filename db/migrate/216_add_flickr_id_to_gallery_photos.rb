class AddFlickrIdToGalleryPhotos < ActiveRecord::Migration
  def self.up
    add_column :gallery_photos, :flickr_id, :string
  end

  def self.down
    remove_column :gallery_photos, :flickr_id
  end
end
