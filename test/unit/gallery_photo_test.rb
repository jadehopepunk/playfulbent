# == Schema Information
#
# Table name: gallery_photos
#
#  id           :integer(4)      not null, primary key
#  created_on   :datetime
#  title        :string(255)     default("Untitled")
#  position     :integer(4)
#  photo_set_id :integer(4)
#  type         :string(255)
#  flickr_id    :string(255)
#  server       :string(255)
#  secret       :string(255)
#  version      :integer(4)      default(1)
#

require File.dirname(__FILE__) + '/../test_helper'

class GalleryPhotoTest < Test::Unit::TestCase

  def test_truth
    assert true
  end
    
end
