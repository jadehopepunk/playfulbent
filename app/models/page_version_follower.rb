# == Schema Information
#
# Table name: page_version_followers
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  page_version_id :integer(4)
#  created_on      :datetime
#

class PageVersionFollower < ActiveRecord::Base
  belongs_to :follower, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :page_version
  validates_presence_of :user_id, :page_version_id
  
  
end
