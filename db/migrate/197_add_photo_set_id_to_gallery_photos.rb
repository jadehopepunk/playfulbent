class AddPhotoSetIdToGalleryPhotos < ActiveRecord::Migration
  def self.up
    add_column :gallery_photos, :photo_set_id, :integer
    add_index :gallery_photos, :photo_set_id
  end

  def self.down
    remove_index :gallery_photos, :photo_set_id
    remove_column :gallery_photos, :photo_set_id
  end
end
