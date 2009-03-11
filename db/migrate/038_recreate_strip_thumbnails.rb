class RecreateStripThumbnails < ActiveRecord::Migration
   include FileColumnHelper

   def self.up
      for photo in StripPhoto.find(:all)
         unless photo.image.nil?
            thumb = File.dirname(photo.image) + "/thumb/"
            preview = File.dirname(photo.image) + "/preview/"

            FileUtils.rm_r(thumb) if File.exists? thumb
            FileUtils.rm_r(preview) if File.exists? preview
            
            photo.send("image_state").create_magick_version_if_needed :thumb
         end
      end
   end

   def self.down
   end
end
