class CreateActivitiesForGalleryPhotos < ActiveRecord::Migration
  def self.up
    for photo in GalleryPhoto.find(:all)
      activity = ActivityCreatedGalleryPhoto.create_for(photo)
      activity.update_attribute(:created_at, photo.created_on)
    end
  end

  def self.down
  end
end
