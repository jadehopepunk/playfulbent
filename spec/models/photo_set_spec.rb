# == Schema Information
#
# Table name: photo_sets
#
#  id              :integer(4)      not null, primary key
#  profile_id      :integer(4)
#  title           :string(255)
#  position        :integer(4)
#  viewable_by     :string(255)
#  minimum_ticks   :integer(4)
#  published       :boolean(1)
#  type            :string(255)
#  flickr_set_name :string(255)
#  flickr_set_id   :string(255)
#  flickr_set_url  :string(255)
#  last_fetched_at :datetime
#  version         :integer(4)      default(1)
#

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
