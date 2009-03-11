# == Schema Information
# Schema version: 258
#
# Table name: story_subscriptions
#
#  id                     :integer(11)   not null, primary key
#  story_id               :integer(11)   
#  user_id                :integer(11)   
#  continue_page_i_wrote  :boolean(1)    default(true)
#  continue_page_i_follow :boolean(1)    
#

class StorySubscription < ActiveRecord::Base
  belongs_to :story
  belongs_to :user
  validates_presence_of :story_id, :user_id
  validates_uniqueness_of :story_id, :scope => :user_id
  
  def can_be_modified_by(other_user)
    !user.nil? && user == other_user
  end
  
end
