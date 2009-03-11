class RemoveProfileIdFromGalleryPhotos < ActiveRecord::Migration
  def self.up
    remove_column :gallery_photos, :profile_id
  end

  def self.down
    add_column :gallery_photos, :profile_id, :integer
  end
end
