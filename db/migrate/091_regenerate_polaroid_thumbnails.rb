class RegeneratePolaroidThumbnails < ActiveRecord::Migration
  def self.up
    for avatar in Avatar.find(:all)
       unless avatar.image.nil?
         polaroid = File.dirname(avatar.image) + "/polaroid/"
         FileUtils.rm_r(polaroid) if File.exists? polaroid
         
         avatar.send("image_state").create_magick_version_if_needed :polaroid
       end
    end
  end

  def self.down
  end
end
