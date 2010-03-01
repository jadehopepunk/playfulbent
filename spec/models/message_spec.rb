# == Schema Information
#
# Table name: messages
#
#  id           :integer(4)      not null, primary key
#  sender_id    :integer(4)
#  recipient_id :integer(4)
#  subject      :string(255)
#  body         :text
#  created_on   :datetime
#  parent_id    :integer(4)
#

require File.dirname(__FILE__) + '/../spec_helper'

describe Message, "when creating from email" do
  
  before do
    clear_tables Email, Message, User
    @email = model_factory.email
    @user = model_factory.user
    @recipient = @email.recipient
  end
  
  it "should create a valid message" do
    result = Message.create_from_email(@email, @user)
    result.should_not be_nil
    result.should_not be_new_record
  end
  
  it "should populate body from email text body" do
    result = Message.create_from_email(@email, @user)
    result.body.should == "Some Stuff\n\n-----\nCraig Ambrose\nwww.craigambrose.com\n"
  end
  
  it "should set sender" do
    result = Message.create_from_email(@email, @user)
    result.sender == @user
  end
  
  it "should set recipient from email" do
    result = Message.create_from_email(@email, @user)
    result.recipient.should == @recipient
  end
  
  it "shold set subject from email" do
    result = Message.create_from_email(@email, @user)
    result.subject.should == 'testing'
  end
    
end
