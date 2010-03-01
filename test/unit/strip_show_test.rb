# == Schema Information
#
# Table name: strip_shows
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  finished     :boolean(1)
#  title        :string(255)
#  published_at :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class StripShowTest < Test::Unit::TestCase
  fixtures :strip_shows, :profiles, :users, :email_addresses, :strip_photos, :strip_show_views, :strip_photo_views

  #----------------------------------------------------------------
  # PUBLISH
  #----------------------------------------------------------------

  def test_publish_tells_first_photo_to_publish
    show = StripShow.new

    first_photo = StripPhoto.new
    show.strip_photos << first_photo
    first_photo.expects(:publish)

    second_photo = StripPhoto.new
    show.strip_photos << second_photo
    first_photo.expects(:publish).never
    
    show.publish
  end
  
  #----------------------------------------------------------------
  # FIND ALL PUBLISHED
  #----------------------------------------------------------------

  def test_find_all_published_doesnt_return_stripshows_for_disabled_profile
    result = StripShow.find_all_published
    assert result.map(&:user).include?(users(:sponsoring_sam))
    assert !result.map(&:user).include?(users(:disabled))
  end
  
  #----------------------------------------------------------------
  # DESTROY
  #----------------------------------------------------------------
  
  def test_that_destroying_stripshow_destroys_strip_photos
    assert StripPhoto.exists?(1)
    strip_shows(:sams_show).destroy
    assert !StripPhoto.exists?(1)
  end

  def test_that_destroying_stripshow_destroys_strip_show_views
    assert StripShowView.exists?(1)
    strip_shows(:sams_show).destroy
    assert !StripShowView.exists?(1)
  end
  
  #----------------------------------------------------------------
  # greatest_position_viewed_by
  #----------------------------------------------------------------

  def test_that_greatest_position_viewed_by_to_is_zero_for_nil_user
    assert_equal 0, strip_shows(:sams_show).greatest_position_viewed_by(nil)
  end

  def test_that_greatest_position_viewed_by_to_is_zero_for_user_who_hasnt_viewed
    assert_equal 0, strip_shows(:sams_show).greatest_position_viewed_by(users(:pippin))
  end

  def test_that_greatest_position_viewed_by_to_is_one_for_user_who_has_viewed_one
    view = StripShowView.new(:strip_show => strip_shows(:sams_show), :user => users(:pippin), :max_position_viewed => 1)
    view.save!
    assert_equal 1, strip_shows(:sams_show).greatest_position_viewed_by(users(:pippin))
  end

  #----------------------------------------------------------------
  # greatest_position_visible_to
  #----------------------------------------------------------------
  
  def test_that_greatest_position_visible_to_is_one_for_nil_user
    assert_equal 1, strip_shows(:sams_show).greatest_position_visible_to(nil)
  end
  
  def test_that_greatest_position_visible_to_is_one_for_user_with_no_stripshow
    assert_equal 1, strip_shows(:sams_show).greatest_position_visible_to(users(:frodo))
  end
  
  def test_that_greatest_position_visible_to_is_two_for_other_user_with_stripsho
    assert_equal 2, strip_shows(:sams_show).greatest_position_visible_to(users(:pippin))
  end
  
  def test_that_greatest_position_visible_to_is_three_if_other_user_has_viewed_our_first_photo
    view = StripShowView.new(:strip_show => strip_shows(:pippins_show), :user => users(:sponsoring_sam), :max_position_viewed => 2)
    view.save!
    assert_equal 3, strip_shows(:sams_show).greatest_position_visible_to(users(:pippin))
  end

end
