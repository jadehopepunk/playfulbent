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

class ActivityContinuedStory < Activity
  belongs_to :story
  belongs_to :page_version
  validates_presence_of :story, :page_version
  
  def self.create_for(page_version)
    create(:story => page_version.story, :page_version => page_version, :actor => page_version.author)
  end
  
  def title
    "A new story page"
  end
  
end
