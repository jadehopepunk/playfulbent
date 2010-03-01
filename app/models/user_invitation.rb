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

class UserInvitation < Invitation
  belongs_to :recipient, :class_name => "User", :foreign_key => "recipient_id"
  validates_presence_of :recipient
  validates_uniqueness_of :recipient_id, :scope => [:user_id, :strip_show_id], :message => 'has already been invited to view this strip-show.'  
  validates_uniqueness_of :recipient_id, :scope => [:user_id, :created_on], :message => 'cannot be invited again today. We don\'t want people to think we\'re spamming them!'  

end
