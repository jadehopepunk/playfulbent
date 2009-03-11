# == Schema Information
# Schema version: 258
#
# Table name: activities
#
#  id               :integer(11)   not null, primary key
#  type             :string(255)   
#  actor_id         :integer(11)   
#  gallery_photo_id :integer(11)   
#  created_at       :datetime      
#  updated_at       :datetime      
#  review_id        :integer(11)   
#  strip_show_id    :integer(11)   
#  dare_id          :integer(11)   
#  dare_response_id :integer(11)   
#  story_id         :integer(11)   
#  page_version_id  :integer(11)   
#  profile_id       :integer(11)   
#

class ActivityCreatedGalleryPhoto < Activity
  belongs_to :gallery_photo  
  validates_presence_of :gallery_photo
  
  def self.create_for(gallery_photo)
    create(:gallery_photo => gallery_photo, :actor => gallery_photo.user)
  end
  
  def title
    "A new photo"
  end
  
  
end
