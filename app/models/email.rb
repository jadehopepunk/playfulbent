# == Schema Information
#
# Table name: emails
#
#  id              :integer(4)      not null, primary key
#  raw             :text
#  recipient_id    :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  processed_at    :datetime
#  email_sender_id :integer(4)
#

class Email < ActiveRecord::Base
  belongs_to :recipient, :class_name => 'User', :foreign_key => :recipient_id
  belongs_to :email_sender
  
  validates_presence_of :raw, :recipient_address
  validate_on_create :validate_against_handlers
  
  def recipient_address
    tmail_method(:header_string, 'X-Original-To')
  end
  
  def header_string(name)
    tmail_method(:header_string, name)
  end
  
  def raw=(value)
    write_attribute(:raw, value)
    self.recipient = find_recipient
    self.sender_address = sender_addr.address if sender_addr
  end
  
  def to_label
    "To #{recipient_address} at #{created_at.to_s}"
  end
  
  def process
    raise ArgumentError, "Can't process already processed email" if processed?
    
    for handler_class in handler_classes
      handler = handler_class.new(self)
      handler.process
      mark_as_processed if handler.processed?
      break if processed? || handler.handled?
    end
  end
  
  def handler_classes
    [EmailHandler::SpamHandler, EmailHandler::AdminHandler, EmailHandler::UserMessageHandler]
  end
  
  def text_body
    text_part.body if text_part
  end
  
  def subject
    tmail.subject
  end
  
  def sender_address
    email_sender.address if email_sender
  end
  
  def sender_name
    sender_addr.name
  end
  
  def verify_sender(user)
    unless processed?
      email_sender.verify(user)
      mark_as_processed
    end
  end
  
  def processed?
    processed_at
  end
  
  def recipient_username
    match_data = recipient_address.match(/^([^@]*)@([^@]*)$/) unless recipient_address.blank?
    match_data[1] if match_data
  end
  
  def recipient_domain
    match_data = recipient_address.match(/^([^@]*)@([^@]*)$/) unless recipient_address.blank?
    match_data[2] if match_data
  end
  
  protected
  
    def validate_against_handlers
      if !raw.blank? && !recipient_address.blank?
        errors.add(:recipient, "can't be blank") unless handler_found_recipient?
      end
    end
    
    def handler_found_recipient?
      for handler_class in handler_classes
        handler = handler_class.new(self)
        return true if handler.found_recipient?
      end
      false
    end
    
    def send_request_to_verify_sender
      CommsMailer.deliver_verify_new_sender(self, sender_address, sender_name)
    end
    
    def sender_address=(value)
      self.email_sender = EmailSender.new(:address => value)
    end
  
    def sender_addr
      tmail.sender_addr(nil) || from_addr
    end
    
    def from_addr
      tmail.from_addrs.first
    end
  
    def text_part
      return tmail if tmail.content_type == "text/plain"
      tmail.each_part do |part|
        return part if part.content_type == "text/plain"
      end
      nil
    end
  
    def mark_as_processed
      update_attribute(:processed_at, Time.now)
    end
  
    def find_recipient
      User.find_by_permalink(recipient_username)
    end
  
    def tmail
      @tmail ||= TMail::Mail.parse(raw) unless raw.blank?
    end
    
    def tmail_method(name, *params)
      tmail.send(name, *params) if tmail
    end
  
end
