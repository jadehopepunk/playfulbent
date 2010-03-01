# == Schema Information
#
# Table name: avatars
#
#  id         :integer(4)      not null, primary key
#  image      :string(255)
#  profile_id :integer(4)
#

require File.dirname(__FILE__) + '/../test_helper'

class AvatarTest < Test::Unit::TestCase
  fixtures :avatars, :profiles, :users, :email_addresses

  def valid_new_avatar(profile)
    Avatar.new(:profile => profile, :image => File.new(File.dirname(__FILE__) + '/../../public/images/blank.gif'))
  end

  def test_that_create_publishes_profile
    profile = profiles(:unpublished)
    avatar = valid_new_avatar(profile)
    avatar.save!
    profile.reload

    assert profile.published
    avatar.destroy
  end

end
