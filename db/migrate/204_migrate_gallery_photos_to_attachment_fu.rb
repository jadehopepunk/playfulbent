class MigrateGalleryPhotosToAttachmentFu < ActiveRecord::Migration
  def self.up
    for gallery_photo in GalleryPhoto.find(:all)
      image_filename = select_value "SELECT image FROM gallery_photos WHERE id = #{gallery_photo.id}" 
      unless image_filename.blank?
        image_path = RAILS_ROOT + "/public/images/system/user/gallery_photo/image/#{gallery_photo.id}/#{image_filename}" 
        begin
          image_file = File.open(image_path, 'r')
        rescue Exception
        else
          gallery_photo_file = GalleryPhotoFile.new(:gallery_photo_id => gallery_photo.id)
          gallery_photo_file.set_from_file(image_file)
          gallery_photo_file.save
        end
      end
    end
  end

  def self.down
  end
end
