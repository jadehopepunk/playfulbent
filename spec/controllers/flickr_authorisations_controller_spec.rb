require File.dirname(__FILE__) + '/../spec_helper'

describe FlickrAuthorisationsController, "create action" do
  
  before do
    @flickr = Flickr.new(nil, AppConfig.flickr_api_key, AppConfig.flickr_shared_secret)
    Flickr.stub!(:new).and_return(@flickr)
    
    @auth = Flickr::Auth.new(@flickr, nil)
    @flickr.stub!(:auth).and_return(@auth)

    @auth.stub!(:login_link).and_return('http://flickrlogin')
  end
  
  it "should require login" do
    post :create
    response.should redirect_to(new_session_url)
  end

  it "should redirect to flickr login url" do
    @auth.should_receive(:login_link).with('read').and_return('http://flickrlogin')
    login
    post :create
    response.should redirect_to('http://flickrlogin')
  end
  
  it "should store the return url in the session" do
    login
    post :create, :return_to => 'http://wallyfish'
    session[:flickr_authorisation].should == {:return_to => 'http://wallyfish'}
  end
  
end

describe FlickrAuthorisationsController, "check action" do
  
  before do
    @account = mock_model(FlickrAccount)
    FlickrAccount.stub!(:create_from_frob).and_return(FlickrAccount)
    login
    @viewer.stub!(:profile_url).and_return('http://jade.test.host')
  end
  
  it "should redirect you to your profile if session contains no flickr authorisation data" do
    get :check
    response.should redirect_to('http://jade.test.host')
  end
  
  it "should redirect you to your profile if session data contains no return to url" do
    session[:flickr_authorisation] = {}
    get :check
    response.should redirect_to('http://jade.test.host')
  end
  
  it "should redirect you to return to url" do
    session[:flickr_authorisation] = {:return_to => 'http://someurl'}
    get :check
    response.should redirect_to('http://someurl')
  end
  
end

