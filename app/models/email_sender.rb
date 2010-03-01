# == Schema Information
#
# Table name: email_senders
#
#  id         :integer(4)      not null, primary key
#  address    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class EmailSender < ActiveRecord::Base
  has_many :emails, :dependent => :nullify
  
  validates_presence_of :address
  
  def verify(user)
    user.email_addresses << to_email_address
    for email in emails
      Message.create_from_email(email, user) unless email.processed?
    end
  end
  
  protected
  
    def to_email_address
      EmailAddress.new(:address => address, :verified_at => Time.now)
    end
  
end
