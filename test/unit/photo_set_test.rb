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
