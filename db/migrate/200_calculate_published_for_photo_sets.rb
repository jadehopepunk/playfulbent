class CalculatePublishedForPhotoSets < ActiveRecord::Migration
  def self.up
    for photo_set in PhotoSet.find(:all)
      if !photo_set.gallery_photos.empty?
        execute "UPDATE photo_sets SET published = 1 WHERE id = #{photo_set.id}"
      end
    end
  end

  def self.down
    execute "UPDATE photo_sets SET published = 0 WHERE"
  end
end
