# == Schema Information
# Schema version: 258
#
# Table name: mailing_list_messages
#
#  id                 :integer(11)   not null, primary key
#  raw_email          :text          
#  subject            :string(255)   
#  sender_address     :string(255)   
#  sender_id          :integer(11)   
#  parent_id          :integer(11)   
#  group_id           :integer(11)   
#  text_body          :text          
#  received_at        :datetime      
#  created_at         :datetime      
#  sender_profile_id  :integer(11)   
#  message_identifier :string(255)   
#

class MailingListMessage < ActiveRecord::Base
  belongs_to :group
  belongs_to :sender_id, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :sender_external_profile, :class_name => 'YahooProfile', :foreign_key => 'sender_profile_id'
  belongs_to :parent, :class_name => 'MailingListMessage', :foreign_key => 'parent_id'
  has_many :children, :class_name => 'MailingListMessage', :foreign_key => 'parent_id'
  
  validates_presence_of :raw_email, :group, :message_identifier
  validates_length_of :subject, :sender_address, :message_identifier, :maximum => 255, :allow_nil => true
  validates_uniqueness_of :message_identifier
  
  after_create :make_sender_a_group_member
    
  def self.identifier_already_exists?(key)
    !key.blank? && exists?(["message_identifier = ?", key])
  end
  
  def parent_message_identifier=(value)
    self.parent = value.blank? ? nil : MailingListMessage.find_by_message_identifier(value)
  end
  
  def update_from_raw_email
    Yahoo::MailReader.new.update_message_from_email(self, TMail::Mail.parse(raw_email))
  end
  
  def sender_name
    sender_external_profile.name if sender_external_profile
  end
  
  def sender_url
    sender_external_profile.profile_url if sender_external_profile
  end
  
  def descendents
    children.empty? ? [self] : children.map(&:descendents).flatten
  end
  
  protected
  
    def group_name
      group.group_name if group
    end
    
    def make_sender_a_group_member
      group.make_member(sender_external_profile) if group && sender_external_profile
    end
        
end
