# == Schema Information
#
# Table name: activities
#
#  id               :integer(4)      not null, primary key
#  type             :string(255)
#  actor_id         :integer(4)
#  gallery_photo_id :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#  review_id        :integer(4)
#  strip_show_id    :integer(4)
#  dare_id          :integer(4)
#  dare_response_id :integer(4)
#  story_id         :integer(4)
#  page_version_id  :integer(4)
#  profile_id       :integer(4)
#

class ActivityCreatedDareResponse < Activity
  belongs_to :dare_response
  validates_presence_of :dare_response
  
  def self.create_for(dare_response)
    create(:dare_response => dare_response, :actor => dare_response.user)
  end
  
  def title
    "A dare fullfilled"
  end
  
end
