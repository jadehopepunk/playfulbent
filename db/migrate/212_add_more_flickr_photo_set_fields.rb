class AddMoreFlickrPhotoSetFields < ActiveRecord::Migration
  def self.up
    rename_column :photo_sets, :flickr_photo_set_name, :flickr_set_name
    add_column :photo_sets, :flickr_set_id, :string
    add_column :photo_sets, :flickr_set_url, :string
  end

  def self.down
    remove_column :photo_sets, :flickr_set_url
    remove_column :photo_sets, :flickr_set_id
    rename_column :photo_sets, :flickr_set_name, :flickr_photo_set_name
  end
end
