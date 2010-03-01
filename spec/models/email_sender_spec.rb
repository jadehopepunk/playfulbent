# == Schema Information
#
# Table name: email_senders
#
#  id         :integer(4)      not null, primary key
#  address    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require File.dirname(__FILE__) + '/../spec_helper'

describe EmailSender do
  before(:each) do
    EmailSender.destroy_all
    @email_sender = EmailSender.new(:address => 'craig@craigambrose.com')
  end

  it "should be valid" do
    @email_sender.should be_valid
  end
end

describe EmailSender, "when verifying" do
  before do
    EmailSender.destroy_all
    User.destroy_all    
    EmailAddress.destroy_all
    Email.destroy_all
    Message.destroy_all
    
    @email = model_factory.email

    @email_sender = EmailSender.new(:address => 'craig@earthsong.org.nz')
    @email_sender.emails << @email
    @email.save!
    
    @jade = model_factory.user(:email => 'craig@craigambrose.com')
  end

  it "should add an email address to the user" do
    @email_sender.verify(@jade)    
    @jade.email_addresses.last.address.should == 'craig@earthsong.org.nz'
  end
  
  it "should verify the new email address" do
    @email_sender.verify(@jade)    
    @jade.email_addresses.last.should be_verified    
  end
  
  it "should save the new email address" do
    @email_sender.verify(@jade)    
    @jade.email_addresses.last.should_not be_new_record
  end
  
  it "should save new email addresses association with user" do
    @email_sender.verify(@jade)    
    @jade.email_addresses.last.reload.user.should == @jade
  end
  
  it "should cause all emails sent by this sender to be converted to messages and delivered" do
    Message.should_receive(:create_from_email).with(@email, @jade)
    @email_sender.verify(@jade)    
  end
  
  it "should not convert an already processed email to a message" do
    @email.update_attribute(:processed_at, Time.now)
    Message.should_receive(:create_from_email).never
    @email_sender.verify(@jade)    
  end

end
