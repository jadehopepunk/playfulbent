# == Schema Information
# Schema version: 258
#
# Table name: messages
#
#  id           :integer(11)   not null, primary key
#  sender_id    :integer(11)   
#  recipient_id :integer(11)   
#  subject      :string(255)   
#  body         :text          
#  created_on   :datetime      
#  parent_id    :integer(11)   
#

class Message < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :recipient, :class_name => 'User', :foreign_key => 'recipient_id'
  belongs_to :parent, :class_name => 'Message', :foreign_key => 'parent_id'
  
  validates_presence_of :sender, :recipient, :subject, :body
  
  after_create :notify_recipient_via_email, :ensure_interactions_created
  
  def self.possible_recipients_for(user)
    return [] if user.nil?
    if user.is_admin? || user.is_review_manager?
      User.find(:all, :conditions => ["id != ?", user.id], :order => 'nick')
    else
      user.find_others_with_minimum_interactions_or_admin(2)
    end
  end
  
  def self.unread_message_count_for(user, sender = nil)
    if sender
      user.received_messages.count(:conditions => {:sender_id => sender.id}) - user.received_messages.count('DISTINCT messages.id', :conditions => ["messages.sender_id = ? AND message_readings.user_id = ?", sender.id, user.id], :joins => 'LEFT JOIN message_readings ON messages.id = message_readings.message_id')
    else
      user.received_messages.count - user.message_readings.count
    end
  end
  
  def self.create_from_email(email, sender)
    create(:body => email.text_body, :sender => sender, :recipient => email.recipient, :subject => email.subject)
  end
  
  def can_be_edited_by?(other_user)
    sender && (sender == other_user || other_user.is_admin?)
  end
  
  def read_by?(other_user)
    return false if other_user.nil? || other_user.new_record? || new_record?
    MessageReading.exists?(:user_id => other_user.id, :message_id => id)
  end
  
  def read(other_user)
    unless read_by? other_user
      raise ArgumentError if other_user.nil? || other_user.new_record? || new_record?
      MessageReading.create(:user_id => other_user.id, :message_id => id)
    end
  end
  
protected
  
  def notify_recipient_via_email
    begin
      NotificationsMailer.deliver_new_message self
    rescue Net::SMTPSyntaxError
    end
  end
  
  def ensure_interactions_created
    InteractionExchangeMessages.create_if_meets_criteria(sender, recipient)
    InteractionExchangeMessages.create_if_meets_criteria(recipient, sender)
  end
  
  
end
