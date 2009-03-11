require File.dirname(__FILE__) + '/../spec_helper'

module FlickrPhotoSetHelper
  
  def valid_photo_set_attributes
    {:profile => Profile.new, :title => 'valid title', :username => 'craig', :password => 'password'}
  end
  
end

describe FlickrPhotoSet do
  include FlickrPhotoSetHelper
  
  before(:each) do
    @flickr_account = mock_model(FlickrAccount)
    @flickr_account.stub!(:external_photo_set).and_return(nil)
    
    @profile = model_factory.profile
    @user = @profile.user
    @user.stub!(:flickr_account).and_return(@flickr_account)
    
    @set = FlickrPhotoSet.new(:profile => @profile)
  end
  
  it "should be valid" do
    @set.flickr_set_id = "abcdef"
    @set.title = 'valid title'
    @flickr_account.should_receive(:owns_photo_set?).with('abcdef').and_return(true)    
    
    @set.should be_valid
  end

  it "should be a photo set" do
    @set.should be_a_kind_of(PhotoSet)
  end
  
  it "should have a type name of 'FlickrPhotoSet'" do
    @set.type_name.should == 'FlickrPhotoSet'
  end
  
  it "should require a flickr set id" do
    @set.valid?
    @set.errors.on(:flickr_set_id).should_not be_nil
  end
  
  it "should require user to have a flickr account" do
    @user.stub!(:flickr_account).and_return(nil)
    @set.should_not be_valid
    @set.errors.on_base.should include("This user does not have a valid flickr account.")
  end
  
  it "should require flickr_set_id to belong to current users flickr account" do
    @set.flickr_set_id = "abcdef"
    @flickr_account.should_receive(:owns_photo_set?).with('abcdef').and_return(false)    
    @set.valid?
    @set.errors.on(:flickr_set_id).should_not be_nil
    @set.errors.on(:flickr_set_id).should include("isn't owned by this user.")
  end
  
  
end

