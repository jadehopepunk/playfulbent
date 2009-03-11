class SetMissingTypeFieldOnPhotoSets < ActiveRecord::Migration
  def self.up
    execute "UPDATE photo_sets SET type = 'LocalPhotoSet' WHERE type IS NULL OR type = '' OR type = 'PhotoSet'"
  end

  def self.down
  end
end
