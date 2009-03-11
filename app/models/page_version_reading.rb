# == Schema Information
# Schema version: 258
#
# Table name: page_version_readings
#
#  id              :integer(11)   not null, primary key
#  page_version_id :integer(11)   
#  story_id        :integer(11)   
#  user_id         :integer(11)   
#  created_at      :datetime      
#

class PageVersionReading < ActiveRecord::Base
  belongs_to :page_version
  belongs_to :user
  belongs_to :story
  
  validates_uniqueness_of :user_id, :scope => :page_version_id
  validates_presence_of :story_id
  
end
