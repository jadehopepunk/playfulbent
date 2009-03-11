class AddFlickrUsernameToPhotoSets < ActiveRecord::Migration
  def self.up
    add_column :photo_sets, :username, :string
  end

  def self.down
    remove_column :photo_sets, :username
  end
end
