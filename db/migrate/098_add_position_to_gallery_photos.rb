class AddPositionToGalleryPhotos < ActiveRecord::Migration
  def self.up
    add_column :gallery_photos, :position, :integer
    
    for profile in Profile.find(:all)
      count = 1
      for photo in GalleryPhoto.find(:all, :conditions => {:profile_id => profile.id})
        photo.position = count
        photo.save!
        count += 1
      end
    end
  end

  def self.down
    remove_column :gallery_photos, :position
  end
end
