require File.dirname(__FILE__) + '/../spec_helper'

describe Email do  
  it "should require raw data" do
    email = Email.create
    email.should_not be_valid
    email.errors.on(:raw).should == "can't be blank"
  end
end

describe Email, "with no recipient address" do
  before do
    User.destroy_all
    @jade = model_factory.user(:nick => 'Jade')

    @email = Email.create(:raw => load_email(:to_no_one))
  end

  it "should be invalid" do
    @email.should_not be_valid
    @email.errors.on(:recipient_address).should == "can't be blank"
  end
  
  it "shouldn't have a recipient user" do
    @email.recipient.should be_nil
  end  
end

describe Email, "to user" do
  before do
    User.destroy_all
    @jade = model_factory.user(:nick => 'Jade')

    @email = Email.create(:raw => load_email(:to_jade))
  end
  
  it "should be valid" do
    @email.should be_valid
  end

  it "should expose the recipient address" do
    @email.recipient_address.should == 'jade@playfulbent.com'
  end
  
  it "should expose the recipient user" do
    @email.recipient.should == @jade
  end
  
  it "should save recipient id" do
    Email.find_by_recipient_id(@jade.id).should == @email
  end
  
  it "should return sender address" do
    @email.sender_address.should == 'craigambrose@gmail.com'
  end
  
  it "should save a sender record associated with this email" do
    @email.email_sender.should_not be_nil
    @email.email_sender.should_not be_new_record
    @email.email_sender.address.should == 'craigambrose@gmail.com'
  end
  
end

describe Email, "to admin address" do
  before do
    @email = Email.create(:raw => load_email(:to_suggestions))
  end
  
  it "should be valid" do
    @email.should be_valid
  end
  
  it "should email the support address when processed" do
    CommsMailer.should_receive(:deliver_passthrough).with(@email, AppConfig.support_address)
    @email.process
  end
  
  it "should save processed at as current time when processed" do
    CommsMailer.stub!(:deliver_passthrough)
    @email.process    
    @email.reload
    
    @email.processed_at.should_not be_nil
    @email.processed_at.should > 3.seconds.ago
  end
  
end

describe Email, "in plain text format" do
  before do
    User.destroy_all
    @jade = model_factory.user(:nick => 'Jade')
    @email = Email.create(:raw => load_email(:to_jade))
  end
  
  it "should use the full email body as the text body" do
    @email.text_body.should == "Some Stuff\n\n-----\nCraig Ambrose\nwww.craigambrose.com\n"
  end  
end

describe Email, "in multi part text and html format" do
  before do
    @email = Email.create(:raw => load_email(:to_suggestions))
  end
  
  it "should use the plain text part as the text body" do
    @email.text_body.should == "Top international lovers choose blue-pill. Join them!\n"
  end
end

describe Email, "in html format only" do
  before do
    @email = Email.create(:raw => load_email(:html_only))
  end

  it "should should have an nil text body" do
    @email.text_body.should be_nil
  end  
end

describe Email, "when verifying sender" do
  before do
    @email = Email.create(:raw => load_email(:to_jade))
    @email_sender = @email.email_sender
    @user = model_factory.user
  end
  
  it "should verify the email send" do
    @email_sender.should_receive(:verify).with(@user)
    @email.verify_sender(@user)
  end
  
  it "should save processed at as current time" do
    @email.verify_sender(@user)
    
    @email.processed_at.should_not be_nil
    @email.processed_at.should > 3.seconds.ago
  end
  
  it "should do nothing if the email is already processed" do
    @email_sender.should_receive(:verify).never
    @email.update_attribute(:processed_at, 7.days.ago)    
    
    @email.verify_sender(@user)
        
    @email.processed_at.should < 7.days.ago
  end
  
end