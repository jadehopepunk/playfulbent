class AddTypeToGalleryPhotos < ActiveRecord::Migration
  def self.up
    add_column :gallery_photos, :type, :string
    execute "UPDATE gallery_photos SET type = 'LocalGalleryPhoto'"
  end

  def self.down
    remove_column :gallery_photos, :type
  end
end
