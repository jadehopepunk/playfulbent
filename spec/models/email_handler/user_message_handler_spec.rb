require File.dirname(__FILE__) + '/../../spec_helper'

describe EmailHandler::UserMessageHandler, "for email with no matching recipient" do
  before do
    @email = Email.create(:raw => load_email(:to_jade))
    @handler = EmailHandler::UserMessageHandler.new(@email)
  end

  it "should not find recipient" do
    (!!@handler.found_recipient?).should == false
  end
  
end

describe EmailHandler::UserMessageHandler, "to user from unknown address" do
  before do
    clear_tables User, Email
    @jade = model_factory.user(:nick => 'Jade')
    @email = Email.create(:raw => load_email(:to_jade))
    @handler = EmailHandler::UserMessageHandler.new(@email)
  end

  it "should find recipient" do
    (!!@handler.found_recipient?).should == true
  end

  it "should send verify_new_sender message to sender" do
    CommsMailer.should_receive(:deliver_verify_new_sender).with(@email, 'craigambrose@gmail.com', 'Craig Ambrose')
    @handler.process
  end
  
  it "should not consider the email to be processed" do
    CommsMailer.stub!(:deliver_verify_new_sender)
    @handler.process    
    (!!@handler.processed?).should == false
  end
end

describe EmailHandler::UserMessageHandler, "to user from known address" do
  before do
    clear_tables User, Email
    @jade = model_factory.user(:nick => 'Jade', :email => 'jade@craigambrose.com')
    @sending_user = model_factory.user(:nick => 'Craig', :email => 'craigambrose@gmail.com')
    @email = Email.create(:raw => load_email(:to_jade))
    @handler = EmailHandler::UserMessageHandler.new(@email)
  end
  
  it "should not send verify_new_sender message to sender" do
    CommsMailer.should_receive(:deliver_verify_new_sender).never
    @handler.process
  end
  
  it "should consider email to be processed" do
    @handler.process    
    (!!@handler.processed?).should == true
  end
  
  it "should verify the sender" do
    @email.email_sender.should_receive(:verify).with(@sending_user)
    @handler.process    
  end
end

describe EmailHandler::UserMessageHandler, "to valid username at invalid domain" do
  before do
    clear_tables User, Email
    @jade = model_factory.user(:nick => 'Jade', :email => 'jade@craigambrose.com')
    @craig = model_factory.user(:nick => 'Craig', :email => 'craigambrose@gmail.com')
    @email = mock_model(Email, :recipient => @craig, :recipient_domain => 'google.com')
    @handler = EmailHandler::UserMessageHandler.new(@email)
  end

  it "should not find recipient" do
    (!!@handler.found_recipient?).should == false
  end
end
