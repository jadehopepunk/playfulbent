require File.dirname(__FILE__) + '/../spec_helper'

module PhotoSetsControllerSpecHelper
    
  def stub_owner(attributes = {})
    @profile = model_factory.profile
    @owner = @profile.user
    User.stub!(:find).and_return(@owner)
    @owner.stub!(:flickr_account).and_return(nil)
  end
  
  def stub_tabs
    controller.stub!(:load_profile_tabs)
  end
  
  def valid_attributes
    {'title' => 'Naked Shots'}
  end
  
end

describe "user tab page", :shared => true do
  
  it "should load profile tabs" do
    controller.should_receive(:load_profile_tabs)
    make_request
  end
  
end

describe PhotoSetsController, "when logged out" do
  before do
    @user = model_factory.user
  end

  it "should redirect to login on create" do
    post :create, :user_id => @user.id
    response.should redirect_to(new_session_url)
  end
  
  it "should redirect to login on new" do
    get :new, :user_id => @user.id
    response.should redirect_to(new_session_url)
  end

  it "should redirect to login on destroy" do
    delete :destroy, :user_id => @user.id, :photo_set_id => 1
    response.should redirect_to(new_session_url)
  end

end

describe PhotoSetsController, "when logged in as user other than the owner" do
  include PhotoSetsControllerSpecHelper

  before do
    stub_owner :can_be_edited_by? => false
    login
  end

  it "should deny access to create" do
    post :create, :user_id => 1
    response.should be_forbidden
  end

  it "should deny access to new" do
    get :new, :user_id => 1
    response.should be_forbidden
  end

end

describe PhotoSetsController, "new action" do
  
  include PhotoSetsControllerSpecHelper
  
  before do
    stub_tabs
    stub_owner :can_be_edited_by? => true
    login @owner
  end

  it "should return success" do
    get :new, :user_id => 1
    response.should be_success
  end
  
  it "should instatiate a photo set" do
    get :new, :user_id => 1
    assigns[:photo_set].class.name.should == 'PhotoSet'
  end
  
  it "should instantiate a flickr photo set if type name is specified as flickr" do
    get :new, :user_id => 1, 'type_name' => 'FlickrPhotoSet'
    assigns[:photo_set].class.name.should == 'FlickrPhotoSet'
  end
  
end

describe PhotoSetsController, "create action, with invalid data" do
  include PhotoSetsControllerSpecHelper
  
  before do
    stub_tabs
    stub_owner :can_be_edited_by? => true
    login @owner
  end
  
  def make_request
    post :create, :user_id => 1
  end
  
  it_should_behave_like "user tab page"
  
  it "should redisplay form" do
    make_request
    response.should be_success
    response.should render_template('new')    
  end
  
  it "shouldn't contact flickr" do
    Flickr.should_not_receive(:new)
    make_request
  end
  
end

describe PhotoSetsController, "create action" do
  include PhotoSetsControllerSpecHelper
  
  before do
    stub_tabs
    stub_owner :can_be_edited_by? => true
    login @owner
    
    @photo_set = mock_model(PhotoSet, :profile= => nil, :save => true)
    LocalPhotoSet.stub!(:new).and_return(@photo_set)
    FlickrPhotoSet.stub!(:new).and_return(@photo_set)
  end
  
  def make_request
    post :create, :user_id => 1, :photo_set => valid_attributes
  end

  it_should_behave_like "user tab page"
  
  it "should create photo set from attributes" do
    LocalPhotoSet.should_receive(:new).with(valid_attributes).and_return(@photo_set)
    @photo_set.should_receive(:save).and_return(true)    
    make_request
  end
  
  it "should set the photo sets profile to the owners profile" do
    @photo_set.should_receive(:profile=).with(@owner.profile)
    make_request
  end

  it "should redirect to index" do
    make_request
    response.should redirect_to(user_photo_set_url(@owner, @photo_set))
  end
  
  it "should assign the photo set to the view" do
    make_request
    assigns(:photo_set).should == @photo_set
  end
  
  it "should create a local photo set by default" do
    LocalPhotoSet.should_receive(:new).with(valid_attributes).and_return(@photo_set)
    make_request
  end
  
  it "should create a local photo set if LocalPhotoSet type is specified" do
    attributes = {'type_name' => 'LocalPhotoSet', 'title' => 'stuff'}
    LocalPhotoSet.should_receive(:new).with({'title' => 'stuff'}).and_return(@photo_set)
    post :create, :user_id => 1, :photo_set => attributes
  end
  
  it "should create a flickr photo set if FlickrPhotoSet type is specified" do
    attributes = {'type_name' => 'FlickrPhotoSet', 'title' => 'stuff'}
    FlickrPhotoSet.should_receive(:new).with({'title' => 'stuff'}).and_return(@photo_set)
    post :create, :user_id => 1, :photo_set => attributes
  end
  
  it "should assign flickr account if one exists" do
    account = mock_model(FlickrAccount)
    @owner.stub!(:flickr_account).and_return(account)
    make_request
    assigns[:flickr_account].should == account
  end
  
end

