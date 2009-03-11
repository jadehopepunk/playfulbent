require File.dirname(__FILE__) + '/../spec_helper'

describe PhotoSet, "which is default for a profile" do
  
  before do
    @profile = model_factory.profile
    @photo_set = @profile.photo_sets.first
  end

  it "should be valid" do
    @photo_set.should be_valid
  end
  
  it "cant be saved as viewable by friends" do
    @photo_set.viewable_by = 'friends'
    @photo_set.should_not be_valid
  end
  
  it "cant be saved as viewable by me" do
    @photo_set.viewable_by = 'me'
    @photo_set.should_not be_valid
  end
  
  it "can't be deleted" do
    @photo_set.destroy
    @photo_set.reload.should_not be_new_record
  end
  
end