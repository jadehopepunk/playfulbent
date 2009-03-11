# == Schema Information
# Schema version: 258
#
# Table name: photo_sets
#
#  id              :integer(11)   not null, primary key
#  profile_id      :integer(11)   
#  title           :string(255)   
#  position        :integer(11)   
#  viewable_by     :string(255)   
#  minimum_ticks   :integer(11)   
#  published       :boolean(1)    
#  type            :string(255)   
#  flickr_set_name :string(255)   
#  flickr_set_id   :string(255)   
#  flickr_set_url  :string(255)   
#  last_fetched_at :datetime      
#  version         :integer(11)   default(1)
#

class FlickrPhotoSet < PhotoSet
  
  validates_presence_of :flickr_set_id
  validate_on_create :check_flickr_account, :check_set_ownership
  
  before_validation_on_create :fetch_photoset_details
  
  def sync_with_flickr
    update_attribute(:version, version + 1)
    position = 1
    for flickr_photo in flickr_photos
      photo = find_photo_by_flickr_id(flickr_photo.id)
      if photo
        photo.update_from_flickr_data(flickr_photo, position, version)
      else
        FlickrGalleryPhoto.create_from_flickr_data(flickr_photo, self, position, version)
      end
      position += 1
    end
    delete_photos_no_longer_present
    self.last_fetched_at = Time.now
    save!
  end
  
  def find_photo_by_flickr_id(flickr_photo_id)
    gallery_photos.find(:first, :conditions => ["flickr_id = ?", flickr_photo_id])
  end
  
  def self.process_next
    set = FlickrPhotoSet.find(:first, :conditions => ["last_fetched_at IS NULL OR last_fetched_at < ?", 1.day.ago.to_s(:db)], :order => "last_fetched_at IS NULL DESC")
    set.sync_with_flickr if set
    set
  end
  
  def performing_first_import?
    !last_fetched_at
  end
  
  def flickr_nsid
    flickr_account.nsid if flickr_account
  end
  
  protected
  
    def delete_photos_no_longer_present
      results = FlickrGalleryPhoto.find(:all, :conditions => ["photo_set_id = ? AND version < ?", id, version])
      FlickrGalleryPhoto.destroy_all(["photo_set_id = ? AND version < ?", id, version])
    end
  
    def flickr_photos
      flickr_photoset.fetch
    end
  
    def flickr_photoset
      @flickr_photoset || @flickr_photoset = Flickr::PhotoSet.new(flickr_set_id, flickr)
    end
  
    def check_flickr_account
      errors.add_to_base("This user does not have a valid flickr account.") unless flickr_account
      true
    end
    
    def check_set_ownership
      if flickr_account && !flickr_set_id.blank? && !flickr_account.owns_photo_set?(flickr_set_id)
        errors.add(:flickr_set_id, "isn't owned by this user.")
      end
    end
    
    def flickr_account
      user.flickr_account if user
    end
    
    def fetch_photoset_details
      if flickr_account and flickr_set_id
        set = flickr_account.external_photo_set(flickr_set_id)
        if set
          self.flickr_set_name = set.title
          self.flickr_set_url = set.url
        end
      end
    end

    def flickr
      flickr_account.flickr
    end
    
end
