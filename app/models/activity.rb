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

class Activity < ActiveRecord::Base
  belongs_to :actor, :class_name => 'User', :foreign_key => :actor_id  
  validates_presence_of :actor
  
end
