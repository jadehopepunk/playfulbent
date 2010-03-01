# == Schema Information
#
# Table name: strip_photo_views
#
#  id             :integer(4)      not null, primary key
#  strip_photo_id :integer(4)
#  user_id        :integer(4)
#

require File.dirname(__FILE__) + '/../test_helper'

class StripPhotoViewTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :strip_photo_views, :strip_photos, :strip_shows, :strip_show_views
  
  def setup
    @sam = users(:sam)
    @aaron = users(:aaron)
    
    @strip_show = StripShow.new(:user => @aaron)
    
    @photo = StripPhoto.new(:strip_show => @strip_show)
    @photo.stubs(:new_record?).returns(false)
    @photo.stubs(:id).returns(555)
    
    @view = StripPhotoView.new(:strip_photo => @photo, :viewer => @sam)
  end
  
  def test_view_stripshow_interaction_is_created_if_photo_view_is_created_for_last_photo_in_set
    @photo.stubs(:position).returns(15)
    InteractionViewStripshow.expects(:ensure_created).with(@sam, @aaron)

    @view.save
  end
  
  def test_view_stripshow_interaction_is_not_created_if_photo_view_is_created_for_photo_is_set_that_isnt_last
    @photo.stubs(:position).returns(14)
    InteractionViewStripshow.expects(:ensure_created).with(@sam, @aaron).never

    @view.save
  end

  def test_view_stripshow_interaction_is_rechecked_if_photo_view_is_destroyed_for_last_photo_in_set
    @photo.stubs(:position).returns(15)
    @view.save
    InteractionViewStripshow.expects(:ensure_still_valid).with(@sam, @aaron)

    @view.destroy
  end
  
  def test_view_stripshow_interaction_is_rechecked_if_photo_view_is_destroyed_for_photo_in_set_that_isnt_last
    @photo.stubs(:position).returns(14)
    @view.save
    InteractionViewStripshow.expects(:ensure_still_valid).with(@sam, @aaron).never

    @view.destroy
  end

  def test_show_stripshow_interaction_is_created_if_photo_view_is_created_for_last_photo_in_set
    @photo.stubs(:position).returns(15)
    InteractionShowStripshow.expects(:ensure_created).with(@aaron, @sam)

    @view.save
  end
  
  def test_show_stripshow_interaction_is_not_created_if_photo_view_is_created_for_photo_is_set_that_isnt_last
    @photo.stubs(:position).returns(14)
    InteractionShowStripshow.expects(:ensure_created).with(@aaron, @sam).never

    @view.save
  end

  def test_show_stripshow_interaction_is_rechecked_if_photo_view_is_destroyed_for_last_photo_in_set
    @photo.stubs(:position).returns(15)
    @view.save
    InteractionShowStripshow.expects(:ensure_still_valid).with(@aaron, @sam)

    @view.destroy
  end
  
  def test_show_stripshow_interaction_is_rechecked_if_photo_view_is_destroyed_for_photo_in_set_that_isnt_last
    @photo.stubs(:position).returns(14)
    @view.save
    InteractionShowStripshow.expects(:ensure_still_valid).with(@aaron, @sam).never

    @view.destroy
  end
  
  def test_that_create_sets_strip_photo_view
    StripPhotoView.create_for_photo_and_user(strip_photos(:sam5), users(:frodo))
    show_view = StripShowView.find_by_strip_show_and_user(strip_shows(:sams_show), users(:frodo))
    
    assert show_view
    assert_equal 5, show_view.max_position_viewed
  end
  
end
