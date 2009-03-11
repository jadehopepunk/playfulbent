class CopyFirstGallaryPhotosToAvatar < ActiveRecord::Migration
  def self.up
    for profile in Profile.find(:all)
      if !profile.has_avatar? && profile.gallery_photo_count > 0
        photo = profile.gallery_photos.first
        filename = photo.image
        
        avatar = Avatar.new
        avatar.profile = profile
        avatar.image = File.new(filename)
        avatar.save!
      end
    end
  end

  def self.down
  end
end
