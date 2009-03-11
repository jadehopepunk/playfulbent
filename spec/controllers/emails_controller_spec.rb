require File.dirname(__FILE__) + '/../spec_helper'

describe EmailsController, "create action accepting smtp format" do
  integrate_views
  
  before do
    @valid_email = model_factory.email
    @invalid_email = Email.new
  end
  
  it "should return HTTP success code" do
    Email.should_receive(:create).with(:raw => 'raw mail string').and_return(@valid_email)
    post :create, :format => 'smtp', :email => 'raw mail string'
    response.should be_success
  end
  
  it "should return SMTP success code if the address was valid" do
    Email.should_receive(:create).with(:raw => 'raw mail string').and_return(@valid_email)
    post :create, :format => 'smtp', :email => 'raw mail string'
    response.body.should == '250'
  end
  
  it "should return SMTP code 550 (mailbox not found) if address wasn't valid" do
    Email.should_receive(:create).with(:raw => 'raw mail string').and_return(@invalid_email)
    post :create, :format => 'smtp', :email => 'raw mail string'
    response.body.should == '550'
  end
  
  it "should process new email" do
    Email.stub!(:create).and_return(@valid_email)
    @valid_email.should_receive(:process)
    post :create, :format => 'smtp', :email => 'raw mail string'
  end
  
end

describe EmailsController, "verify action" do
  integrate_views

  before do
    @email = model_factory.email
  end
  
  it "should load the email" do
    get :verify, :id => @email.to_param
    assigns(:email).should == @email
  end
  
  it "should have a verify new user form" do
    get :verify, :id => @email.to_param
    response.should have_tag("form[action=/emails/#{@email.to_param}/verify_new_user]")
  end
  
end

describe EmailsController, "verify action when logged in" do
  integrate_views
  
  before do
    @user = model_factory.user
    @email = model_factory.email
    login @user
  end
  
  it "should have a button to verify" do
    get :verify, :id => @email.to_param
    response.should have_tag("form[action=/emails/#{@email.to_param}/update_verified]")
  end
  
  it "should have a change user link" do
    get :verify, :id => @email.to_param
    response.should have_tag("a[href=/session?return_to=%2Femails%2F#{@email.to_param}%2Fverify]")
  end
  
  it "should not have a change user link if email is already processed" do
    @email.update_attribute(:processed_at, Time.now)
    get :verify, :id => @email.to_param
    response.should_not have_tag("a[href=/session?return_to=%2Femails%2F#{@email.to_param}%2Fverify]")
  end
  
end

describe EmailsController, "update verified" do
  integrate_views
  
  before do
    @user = model_factory.user
    @email = model_factory.email
  end

  it "should load the email" do
    login @user
    put :update_verified, :id => @email.to_param
    assigns(:email).should == @email
  end
  
  it "should tell email to verify the sender" do
    login @user
    Email.stub!(:find).and_return(@email)
    @email.should_receive(:verify_sender).with(@user)
    
    put :update_verified, :id => @email.to_param
  end
  
  it "should display a results page" do
    login @user
    put :update_verified, :id => @email.to_param
    response.should be_success
  end
  
  it "should require login" do
    put :update_verified, :id => '1'
    response.should redirect_to(new_session_url)
  end
  
  it "should display a page thanking the user" do
    login @user
    put :update_verified, :id => @email.to_param
    response.should have_tag('H1', 'Message Sent')
  end
  
end

describe EmailsController, "verify new user with invalid details" do
  integrate_views
  
  before do
    @email = model_factory.email
    @user_params = {'foo' => 'bar'}
    @invalid_user = User.new
    User.stub!(:create).and_return(@invalid_user)
  end

  it "should load the email" do
    post :verify_new_user, :id => @email.to_param
    assigns(:email).should == @email
  end
  
  it "should redisplay verify action" do
    post :verify_new_user, :id => @email.to_param, :user => @user_params
    response.should have_tag("form[action=/emails/#{@email.to_param}/verify_new_user]")
  end
  
  it "shouldn't try and log in" do
    @controller.should_receive(:current_user=).never
    post :verify_new_user, :id => @email.to_param, :user => @user_params
  end
  
end

describe EmailsController, "verify new user with valid details" do
  integrate_views
  
  before do
    @email = model_factory.email
    @user_params = {'foo' => 'bar'}
    @valid_user = model_factory.user
    User.stub!(:create).and_return(@valid_user)
  end
  
  it "should create a user" do
    User.should_receive(:create).with(@user_params).and_return(@valid_user)
    post :verify_new_user, :id => @email.to_param, :user => @user_params
  end
  
  it "should log the new user in" do
    @controller.should_receive(:current_user=).with(@valid_user)
    post :verify_new_user, :id => @email.to_param, :user => @user_params
  end

  it "should not create a user if already logged in" do
    login model_factory.user
    User.should_receive(:create).never
    post :verify_new_user, :id => @email.to_param, :user => @user_params    
  end
  
  it "should display a page thanking the user" do
    post :verify_new_user, :id => @email.to_param, :user => @user_params
    response.should be_success
    response.should have_tag("h1", "Message Sent")
  end
  
  it "should verify this email sender" do
    Email.stub!(:find).and_return(@email)
    @email.should_receive(:verify_sender).with(@valid_user)

    post :verify_new_user, :id => @email.to_param, :user => @user_params
  end
    
end