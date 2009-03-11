class RenameGalleryPhotoFileKey < ActiveRecord::Migration
  def self.up
    rename_column :gallery_photo_files, :gallery_photo_id, :local_gallery_photo_id
  end

  def self.down
    rename_column :gallery_photo_files, :local_gallery_photo_id, :gallery_photo_id
  end
end
