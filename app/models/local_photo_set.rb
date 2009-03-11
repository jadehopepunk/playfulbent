# == Schema Information
# Schema version: 258
#
# Table name: photo_sets
#
#  id              :integer(11)   not null, primary key
#  profile_id      :integer(11)   
#  title           :string(255)   
#  position        :integer(11)   
#  viewable_by     :string(255)   
#  minimum_ticks   :integer(11)   
#  published       :boolean(1)    
#  type            :string(255)   
#  flickr_set_name :string(255)   
#  flickr_set_id   :string(255)   
#  flickr_set_url  :string(255)   
#  last_fetched_at :datetime      
#  version         :integer(11)   default(1)
#

class LocalPhotoSet < PhotoSet

  def local?
    true
  end

end
