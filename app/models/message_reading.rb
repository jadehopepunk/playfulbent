# == Schema Information
#
# Table name: message_readings
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  message_id :integer(4)
#  created_at :datetime
#

class MessageReading < ActiveRecord::Base
  belongs_to :user
  belongs_to :message
  
  validates_presence_of :user, :message
  
end
