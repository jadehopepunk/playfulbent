class CreateExternalProfilePhotosFromFileColumn < ActiveRecord::Migration
  def self.up
    for yahoo_profile in YahooProfile.find(:all)
      image_filename = select_value "SELECT image FROM yahoo_profiles WHERE id = #{yahoo_profile.id}"
      unless image_filename.blank?
        image_path = RAILS_ROOT + "/public/system/yahoo_profile/image/#{yahoo_profile.id}/#{image_filename}"
        image_file = File.open(image_path, 'r')
        
        photo = ExternalProfilePhoto.new(:yahoo_profile_id => yahoo_profile.id)
        photo.set_from_file(image_file)
        photo.save!
      end
    end
  end

  def self.down
    execute "DELETE FROM external_profile_photos"
  end
      
end
