class RemoveUsernameFromPhotoSets < ActiveRecord::Migration
  def self.up
    remove_column :photo_sets, :username
  end

  def self.down
    add_column :photo_sets, :username, :string
  end
end
