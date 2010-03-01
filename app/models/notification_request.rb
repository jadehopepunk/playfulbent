# == Schema Information
#
# Table name: notification_requests
#
#  id            :integer(4)      not null, primary key
#  email_address :string(255)
#  created_on    :datetime
#

class NotificationRequest < ActiveRecord::Base

  validates_uniqueness_of :email_address
  validates_presence_of :email_address
  
end
