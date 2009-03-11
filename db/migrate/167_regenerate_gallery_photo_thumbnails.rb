class RegenerateGalleryPhotoThumbnails < ActiveRecord::Migration
  def self.up
    for gallery_photo in GalleryPhoto.find(:all)
       unless gallery_photo.image.nil?
         main = File.dirname(gallery_photo.image) + "/main/"
         FileUtils.rm_r(main) if File.exists? main
         
         gallery_photo.send("image_state").create_magick_version_if_needed :main
       end
    end
  end

  def self.down
  end
end
