# == Schema Information
#
# Table name: gallery_photo_files
#
#  id                     :integer(4)      not null, primary key
#  size                   :integer(4)
#  content_type           :string(255)
#  filename               :string(255)
#  height                 :integer(4)
#  width                  :integer(4)
#  parent_id              :integer(4)
#  thumbnail              :string(255)
#  local_gallery_photo_id :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class GalleryPhotoFileTest < Test::Unit::TestCase
  fixtures :gallery_photo_files

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
