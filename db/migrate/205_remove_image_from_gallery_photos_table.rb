class RemoveImageFromGalleryPhotosTable < ActiveRecord::Migration
  def self.up
    remove_column :gallery_photos, :image
  end

  def self.down
    add_column :gallery_photos, :image, :string
  end
end
