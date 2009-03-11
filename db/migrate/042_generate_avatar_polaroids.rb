class GenerateAvatarPolaroids < ActiveRecord::Migration
  def self.up
    for avatar in Avatar.find(:all)
       unless avatar.image.nil?
          avatar.send("image_state").create_magick_version_if_needed :polaroid
       end
    end
  end

  def self.down
  end
end
