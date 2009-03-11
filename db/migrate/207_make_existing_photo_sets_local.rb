class MakeExistingPhotoSetsLocal < ActiveRecord::Migration
  def self.up
    execute "UPDATE photo_sets SET type = 'LocalPhotoSet'"
  end

  def self.down
  end
end
