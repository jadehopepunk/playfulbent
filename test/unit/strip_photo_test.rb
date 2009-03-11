require File.dirname(__FILE__) + '/../unit_test_helper'

class StripPhotoTest < Test::Unit::TestCase
  fixtures :strip_shows, :strip_photos, :strip_photo_views, :strip_show_views, :users, :email_addresses

  def setup
    @real_user = User.new
    @real_user.stubs(:id).returns(23)
    @real_user.stubs(:new_record?).returns(false)
    
    @photo_owner = User.new
    @photo_owner.stubs(:new_record?).returns(false)

    @photo = StripPhoto.new
    @photo.stubs(:user).returns(@photo_owner)
    @photo.stubs(:id).returns(44)
    @photo.stubs(:new_record?).returns(false)
    
    @published_show = StripShow.new
    @published_show.stubs(:published?).returns(true)
  end
  
  #---------------------------------------------------------
  # HAS BEEN VIEWED BY
  #---------------------------------------------------------

  def test_has_been_viewed_by_defaults_to_false
    StripPhotoView.stubs(:exists_for_photo_and_user).with(@photo, @real_user).returns(false)
    assert_equal false, @photo.has_been_viewed_by(@real_user)
  end
  
  def test_has_been_viewed_by_owner_is_true
    StripPhotoView.stubs(:exists_for_photo_and_user).with(@photo, @photo_owner).returns(false)
    assert_equal true, @photo.has_been_viewed_by(@photo_owner)
  end
  
  def test_has_been_viewed_by_nil_is_false
    assert_equal false, @photo.has_been_viewed_by(nil)
  end
  
  #---------------------------------------------------------
  # VIEW
  #---------------------------------------------------------

  def test_that_strip_photo_view_was_created_by_view
    strip_photos(:sam1).view(users(:pippin))    
    assert_equal 1, strip_shows(:sams_show).greatest_position_viewed_by(users(:pippin))

    strip_photos(:sam2).view(users(:pippin))    
    assert_equal 2, strip_shows(:sams_show).greatest_position_viewed_by(users(:pippin))
  end
  
  def test_view_already_viewed_photo_does_nothing
    StripPhotoView.stubs(:exists_for_photo_and_user).with(@photo, @real_user).returns(true)
    @photo.viewers.expects(:<<).with(@real_user).never
    @photo.view(@real_user)
  end
  
  def test_view_nil_does_nothing
    @photo.viewers.expects(:<<).with(@real_user).never
    @photo.view(nil)
  end
  
  def test_view_null_user_does_nothing
    @photo.viewers.expects(:<<).with(@real_user).never
    @photo.view(NullUser.new)
  end
  
  def test_that_view_sends_email_notification
    strip_photos(:sam1).view(users(:pippin))

    StripshowMailer.expects(:deliver_viewed).with(users(:sponsoring_sam), users(:pippin), [strip_photos(:pippin3)])  
    strip_photos(:sam2).view(users(:pippin))
  end
  
  #---------------------------------------------------------
  # PUBLISH
  #---------------------------------------------------------

  def test_publish_copies_thumbnail_to_public_system_directory
    @photo.stubs(:image_dir_name).returns("/fish")
    @photo.stubs(:image_base_name).returns("banana.png")
    
    FileUtils.expects(:mkpath).with(RAILS_ROOT + "/public/system/strip_photo/image/44/thumb/")
    FileUtils.expects(:copy).with("/fish/thumb/banana.png", RAILS_ROOT + "/public/system/strip_photo/image/44/thumb/")
    @photo.publish
  end
  
  #---------------------------------------------------------
  # IMAGE THUMB
  #---------------------------------------------------------

  def test_image_thumb_returns_public_path_if_is_first_image
    @photo.position = 1
    @photo.strip_show = @published_show
    
    @photo.stubs(:image_dir_name).returns("/fish")
    @photo.stubs(:image_base_name).returns("banana.png")
    
    assert_equal RAILS_ROOT + "/public/system/strip_photo/image/44/thumb/banana.png", @photo.image_thumb
  end  
  
  def test_image_thumb_returns_private_path_if_is_not_first_image
    @photo.position = 2
    @photo.strip_show = @published_show
    
    @photo.stubs(:image_dir_name).returns("/fish")
    @photo.stubs(:image_base_name).returns("banana.png")
    
    assert_equal "/fish/thumb/banana.png", @photo.image_thumb
  end

  #---------------------------------------------------------
  # OWNERS
  #---------------------------------------------------------

  def test_owners_returns_user_from_strip_show
    assert_equal [@photo_owner], @photo.owners
  end


end
