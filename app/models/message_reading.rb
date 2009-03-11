# == Schema Information
# Schema version: 258
#
# Table name: message_readings
#
#  id         :integer(11)   not null, primary key
#  user_id    :integer(11)   
#  message_id :integer(11)   
#  created_at :datetime      
#

class MessageReading < ActiveRecord::Base
  belongs_to :user
  belongs_to :message
  
  validates_presence_of :user, :message
  
end
