# == Schema Information
#
# Table name: flickr_accounts
#
#  id         :integer(4)      not null, primary key
#  nsid       :string(255)
#  token      :string(255)
#  username   :string(255)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require File.dirname(__FILE__) + '/../spec_helper'

describe FlickrAccount do
  before(:each) do
    @flickr_account = FlickrAccount.new
    
    @flickr = mock(Flickr)
    Flickr.stub!(:new).and_return(@flickr)
    @auth = mock(Flickr::Auth)
    @auth.stub!(:token=)
    @flickr.stub!(:auth).and_return(@auth)
    
    @photosets = mock(Flickr::PhotoSets)
    @flickr.stub!(:photosets).and_return(@photosets)
    
    @set1 = mock(Flickr::PhotoSet)
    @set1.stub!(:id).and_return('qwerty')
    @set2 = mock(Flickr::PhotoSet)
    @set2.stub!(:id).and_return('asdf')
    @photosets.stub!(:getList).and_return([@set1, @set2])
  end

  it "should be valid" do
    @flickr_account.should be_valid
  end
  
  it "should own photo set" do
    @flickr_account.owns_photo_set?('qwerty').should be_true
  end
  
end
