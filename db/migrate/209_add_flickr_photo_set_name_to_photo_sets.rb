class AddFlickrPhotoSetNameToPhotoSets < ActiveRecord::Migration
  def self.up
    add_column :photo_sets, :flickr_photo_set_name, :string
  end

  def self.down
    remove_column :photo_sets, :flickr_photo_set_name
  end
end
