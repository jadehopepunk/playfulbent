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

require File.dirname(__FILE__) + '/../test_helper'

class PhotoSetTest < Test::Unit::TestCase
  fixtures :photo_sets, :users, :email_addresses, :relationships, :profiles

  def setup
    @set = photo_sets(:sams_photos)
  end

  #----------------------------------------------------
  # CAN BE VIEWED BY
  #----------------------------------------------------

  def test_viewable_by_all
    @set.viewable_by = ''
    assert @set.can_be_viewed_by?(nil)
    assert @set.can_be_viewed_by?(users(:sam))
  end

  # def test_viewable_by_me
  #   @set.viewable_by = 'me'
  #   assert !@set.can_be_viewed_by?(nil)
  #   assert !@set.can_be_viewed_by?(users(:frodo))
  #   assert @set.can_be_viewed_by?(users(:sam))
  # end
  # 
  # def test_viewable_by_friends
  #   @set.viewable_by = 'friends'
  #   assert !@set.can_be_viewed_by?(nil)
  #   assert !@set.can_be_viewed_by?(users(:frodo))
  #   assert @set.can_be_viewed_by?(users(:sam))
  # end

end
