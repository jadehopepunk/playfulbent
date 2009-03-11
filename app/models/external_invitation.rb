# == Schema Information
# Schema version: 258
#
# Table name: invitations
#
#  id            :integer(11)   not null, primary key
#  name          :string(255)   
#  email_address :string(255)   
#  user_id       :integer(11)   
#  message       :text          
#  strip_show_id :integer(11)   
#  created_on    :date          
#  type          :string(255)   
#  recipient_id  :integer(11)   
#

class ExternalInvitation < Invitation
  validates_presence_of :name, :email_address
  validates_uniqueness_of :email_address, :scope => [:user_id, :strip_show_id], :message => 'cannot be used again for the same strip-show.'  
  validates_uniqueness_of :email_address, :scope => [:user_id, :created_on], :message => 'cannot be used again today. We don\'t want people to think we\'re spamming them!'  

end
