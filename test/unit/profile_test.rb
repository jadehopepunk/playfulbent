# == Schema Information
#
# Table name: profiles
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  created_on   :integer(4)
#  welcome_text :text(16777215)
#  published    :boolean(1)
#  disabled     :boolean(1)
#  location_id  :integer(4)
#

require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < Test::Unit::TestCase
  fixtures :profiles, :users, :email_addresses, :genders, :avatars, :locations, :interests, :kinks, :tags

  #-----------------------------------------------------
  # CAN BE EDITED BY
  #-----------------------------------------------------
  
  def test_cant_be_edited_by_nil_users
    profile = Profile.new
    assert_equal false, profile.can_be_edited_by?(nil)
  end
  
  def test_cant_be_edited_if_user_different_to_profile_owner
    fred = User.new
    sam = User.new
    profile = Profile.new
    profile.user = fred
    assert_equal false, profile.can_be_edited_by?(sam)
  end
  
  def test_can_be_edited_if_user_is_profile_owner
    fred = User.new
    profile = Profile.new
    profile.user = fred
    assert_equal true, profile.can_be_edited_by?(fred)
  end
  
  #-----------------------------------------------------
  # AVATAR IMAGE URL
  #-----------------------------------------------------
  
  def test_avatar_image_url_returns_image_url_from_avatar
    avatar = Avatar.new
    def avatar.image_url
      "banana"
    end
    
    profile = Profile.new
    profile.avatar = avatar
    assert_equal "banana", profile.avatar_image_url
  end
  
  def test_avatar_image_url_returns_default_if_has_no_avatar
    profile = Profile.new
    assert_equal Avatar.blank_image_url, profile.avatar_image_url    
  end

  #-----------------------------------------------------
  # AVATAR THUMB IMAGE URL
  #-----------------------------------------------------
  
  def test_avatar_thumb_image_url_returns_thumb_image_url_from_avatar
    avatar = Avatar.new
    def avatar.thumb_image_url
      "grapefruit"
    end
    
    profile = Profile.new
    profile.avatar = avatar
    assert_equal "grapefruit", profile.avatar_thumb_image_url
  end
  
  def test_avatar_thumb_image_url_returns_default_if_has_no_avatar
    profile = Profile.new
    assert_equal Avatar.blank_image_url, profile.avatar_thumb_image_url    
  end
  
  #-----------------------------------------------------
  # TITLE
  #-----------------------------------------------------
  
  def test_title_is_user_name
    profile = Profile.new
    frodo = User.new
    frodo.nick = 'Frodo'
    profile.user = frodo
    assert_equal "Frodo", profile.title
  end

  #-----------------------------------------------------
  # OWNERS
  #-----------------------------------------------------
  
  def test_owners_is_user
    user = User.new(:nick => 'frodo')
    profile = Profile.new(:user => user)
    assert_equal [user], profile.owners
  end

  #-----------------------------------------------------
  # UPDATE TAGS
  #-----------------------------------------------------
  
  def test_that_update_tags_doesnt_publish_profile_if_tags_list_is_empty
    profile = profiles(:sam)
    profile.kink_tag_string = ''
    profile.interest_tag_string = ''
    profile.published = false
    profile.welcome_text = nil
    profile.user.gender = nil
    
    profile.update_tags
    
    assert !profile.published
  end
  
  #-----------------------------------------------------
  # SAVE
  #-----------------------------------------------------
  
  def test_saving_does_not_publish_profile
    profile = profiles(:unpublished)
    profile.welcome_text = ''
    assert !profile.published
    profile.save!
    assert !profile.published
  end
  
  def test_writing_welcome_text_publishes_profile
    profile = profiles(:unpublished)
    profile.welcome_text = 'hi'
    profile.save
    assert profile.published
  end
  
  def test_that_creating_profile_creates_kinks
    profile = Profile.new(:user => users(:frodo))
    profile.save!
    assert profile.reload.kinks
  end
  
  def test_that_creating_profile_creates_photo_set
    profile = Profile.new(:user => users(:frodo))
    profile.save!
    profile.reload
    assert !profile.photo_sets.empty?
    assert profile.photo_sets.first.is_a?(LocalPhotoSet)
  end
  
  #-----------------------------------------------------
  # AVATAR IMAGE =
  #-----------------------------------------------------
  
  def test_that_setting_avatar_image_to_nil_leaves_avatar_nil
    profile = profiles(:no_avatar)
    profile.avatar_image = nil

    assert profile.reload.avatar.nil?
  end
  
  def test_that_setting_avatar_image_to_nil_destroys_existing_avatar
    profile = profiles(:sam)
    profile.avatar_image = nil
    
    assert profile.reload.avatar.nil?
  end
  
  def test_that_setting_avatar_image_creates_avatar
    profile = profiles(:no_avatar)
    profile.avatar_image = File.open(RAILS_ROOT + '/test/fixtures/images/logo.gif')
    
    avatar = profile.reload.avatar
    assert avatar
    assert avatar.image_url =~ /system\/user\/avatar\/image\/[0-9]+\/logo\.gif/
  end
  
  def test_that_setting_avatar_updates_avatar_image
    profile = profiles(:sam)
    profile.avatar_image = File.open(RAILS_ROOT + '/test/fixtures/images/logo.gif')
    
    avatar = profile.reload.avatar
    assert avatar
    assert_equal '/system/user/avatar/image/1/logo.gif', avatar.image_url
  end
  
  #-----------------------------------------------------
  # DESTROY
  #-----------------------------------------------------
  
  def test_that_destroying_profile_destroys_location
    assert Location.exists?(1)
    profiles(:sam).destroy
    assert !Location.exists?(1)
  end
  
  #-----------------------------------------------------
  # LOCATION NAME
  #-----------------------------------------------------
  
  def test_that_location_name_returns_name_of_location
    sam = profiles(:sam)
    sam.location.stubs(:name).returns('Fish on Toast')
    assert_equal 'Fish on Toast', sam.location_name
  end
  
  def test_that_location_name_returns_nil_for_user_with_no_location
    assert_equal nil, profiles(:no_avatar).location_name
  end

  #-----------------------------------------------------
  # UPDATE LOCATION WITH
  #-----------------------------------------------------
  
  def test_that_update_location_with_updates_existing_location
    profile = profiles(:sam)
    assert profile.update_location_with(:country => 'France', :city => 'Paris')
    location = profile.reload.location
    assert location
    assert_equal 'France', location.country
    assert_equal 'Paris', location.city
    assert_equal 1, location.id
  end
  
  def test_that_update_location_creates_new_location
    profile = profiles(:no_avatar)
    assert profile.update_location_with(:country => 'France', :city => 'Paris')
    location = profile.reload.location
    assert location
    assert_equal 'France', location.country
    assert_equal 'Paris', location.city
  end
  
  def test_that_update_location_with_empty_and_existing_location_strings_deletes_location
    profile = profiles(:sam)
    assert profile.update_location_with(:country => '', :city => '')
    location = profile.reload.location
    assert_equal nil, location
  end

  def test_that_update_location_with_empty_strings_deletes_location
    profile = profiles(:no_avatar)
    assert profile.update_location_with(:country => '', :city => '')
    location = profile.reload.location
    assert_equal nil, location
  end
  
  def test_that_update_location_with_returns_false_if_validation_fails
    profile = profiles(:sam)
    assert !profile.update_location_with(:country => ('a' * 300), :city => 'stuff')
  end
    
end
