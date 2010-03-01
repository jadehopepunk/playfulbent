# == Schema Information
#
# Table name: invitations
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  email_address :string(255)
#  user_id       :integer(4)
#  message       :text(16777215)
#  strip_show_id :integer(4)
#  created_on    :date
#  type          :string(255)
#  recipient_id  :integer(4)
#

class Invitation < ActiveRecord::Base
  @@MAX_DAILY_MAILS_PER_USER = 20
  
  belongs_to :user
  belongs_to :strip_show
  validates_presence_of :user
  
protected

  def validate_on_create
    if !user.nil? && Invitation.count(:conditions => ["user_id = ?", user.id]) > @@MAX_DAILY_MAILS_PER_USER
      errors.add_to_base("You are only allowed to send #{@@MAX_DAILY_MAILS_PER_USER} invitations out per day from Playful-Bent. This is to prevent spamming. Please try again tomorrow.")
    end
  end

end
