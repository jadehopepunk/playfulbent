class AddMoreFlickrPhotoFields < ActiveRecord::Migration
  def self.up
    add_column :gallery_photos, :server, :string
    add_column :gallery_photos, :secret, :string
  end

  def self.down
    remove_column :gallery_photos, :server
    remove_column :gallery_photos, :secret
  end
end
