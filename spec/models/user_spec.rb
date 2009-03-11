require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  
  before do
    User.destroy_all
    @user = User.new(:nick => 'Bilbo Baggins')
  end
  
  it "should not be able to send message to nil user" do
    @user.can_send_message_to?(nil).should == false
  end
  
  it "cannot have a reserved permalink" do
    @user.nick = 'admin'
    @user.valid?
    @user.should_not be_valid
    @user.errors.on(:permalink).should_not be_nil
  end
  
  it "should require an email address" do
    user = User.new
    user.should_not be_valid
    user.errors.on(:email).should == "can't be blank"
  end
  
end

describe User, "on login" do
  fixtures :users

  it "should set last logged in at to now" do
    user = users(:sam)
    user.on_login
    user.reload
    user.last_logged_in_at.should >= 3.seconds.ago
  end
  
end

describe User, "admin" do
  
  before do
    User.destroy_all
    @admin = User.new
    @admin.is_admin = true
    
    @user = User.new
  end
  
  it "should be able to message any user" do
    @admin.can_send_message_to?(@user).should == true
  end
  
  it "should be able to be messaged by any user" do
    @user.can_send_message_to?(@admin).should == true
  end
  
end

describe User, "review manager" do
  
  before do
    User.destroy_all
    @manager = User.new
    @manager.is_review_manager = true
    
    @user = User.new
  end
  
  it "should be able to message any user" do
    @manager.can_send_message_to?(@user).should == true
  end
  
  it "should be able to be messaged by any user" do
    @user.can_send_message_to?(@manager).should == true
  end
end

describe User, "getting and setting email address" do
  
  before do
    User.destroy_all
    EmailAddress.destroy_all
  end
  
  it "should create an email address record when setting email" do
    user = User.new(:email => 'craig@craigambrose.com')
    user.email_addresses.map(&:address).should include('craig@craigambrose.com')
  end
  
  it "should set the primary email address when setting email" do
    user = User.new(:email => 'craig@craigambrose.com')
    user.primary_email_address.address.should == 'craig@craigambrose.com'
  end
  
  it "should leave the old address in email addresses if changing email" do
    user = model_factory.user(:email => 'moosehead@craigambrose.com')
    user.update_attribute(:email, 'george@craigambrose.com')
    
    user.email_addresses.map(&:address).should include('moosehead@craigambrose.com')
    user.email_addresses.map(&:address).should include('george@craigambrose.com')
  end
  
end

describe User, "creating new dummy" do
  
  before do
    User.destroy_all
    EmailAddress.destroy_all
  end
  
  it "should require email" do
    user = User.new_dummy_for('')
    user.should_not be_valid
    user.errors.on(:email).should == "can't be blank"
  end
  
  it "shouldnt require other field" do
    user = User.new_dummy_for('somenewemail@craigambrose.com')
    user.should be_valid
  end

end

