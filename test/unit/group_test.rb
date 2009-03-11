require File.dirname(__FILE__) + '/../test_helper'

class GroupTest < Test::Unit::TestCase
  fixtures :groups, :users, :email_addresses, :group_memberships, :yahoo_profiles
  
  def setup
    @not_a_member = yahoo_profiles(:not_a_member)
    @craigs_playground = groups(:craigs_playground)
  end

  def test_that_destroying_group_destroys_its_memberships
    assert GroupMembership.exists?(1)
    groups(:craigs_playground).destroy
    assert !GroupMembership.exists?(1)
  end
  
  def test_that_make_member_makes_the_profile_a_member
    assert !@craigs_playground.reload.is_external_member?(@not_a_member)
    @craigs_playground.make_member(@not_a_member)
    assert @craigs_playground.reload.is_external_member?(@not_a_member)
  end
  
  def test_that_is_external_member_is_false_for_nil_member
    assert !@craigs_playground.is_external_member?(nil)
  end
  
  def test_that_is_internal_member_is_false_for_nil_member
    assert !@craigs_playground.is_internal_member?(nil)
  end
  
  def test_that_is_internal_member_is_true_for_member_with_external_profile_which_is_an_external_member
    assert @craigs_playground.is_internal_member?(users(:frodo))
  end
  
  def test_that_calling_make_member_twice_creates_only_one_membership
    @craigs_playground.make_member(@not_a_member)
    @craigs_playground.make_member(@not_a_member)

    assert @craigs_playground.reload.is_external_member?(@not_a_member)
    assert_equal 1, GroupMembership.count(:conditions => {:group_id => @craigs_playground.id, :yahoo_profile_id => @not_a_member.id})
  end
  
  #-----------------------------------------------------
  # MAILING LIST CAN BE READ BY
  #-----------------------------------------------------

  def test_that_public_mailing_list_can_be_read_by_nil_user
    group = Group.new(:archive_access_level => Group::ACCESS_ANYONE)
    assert group.mailing_list_can_be_read_by?(nil)
  end
  
  def test_that_public_mailing_list_can_be_read_by_unrelated_user
    group = Group.new(:archive_access_level => Group::ACCESS_ANYONE)
    assert group.mailing_list_can_be_read_by?(users(:bob))
  end
  
  def test_that_members_mailing_list_cant_be_read_by_nil_user
    group = groups(:craigs_playground)
    group.archive_access_level = Group::ACCESS_MEMBERS_ONLY
    assert !group.mailing_list_can_be_read_by?(nil)
  end
  
  def test_that_members_mailing_list_cant_be_read_by_unrelated_user
    group = groups(:craigs_playground)
    group.archive_access_level = Group::ACCESS_MEMBERS_ONLY
    assert !group.mailing_list_can_be_read_by?(users(:bob))
  end
  
  def test_that_members_mailing_list_can_be_read_by_member_user
    group = groups(:craigs_playground)
    group.archive_access_level = Group::ACCESS_MEMBERS_ONLY
    assert group.mailing_list_can_be_read_by?(users(:frodo))
  end
  
  def test_that_off_mailing_list_cant_be_read_by_member_user
    group = groups(:craigs_playground)
    group.archive_access_level = Group::ACCESS_OFF
    assert !group.mailing_list_can_be_read_by?(users(:frodo))
  end

  #-----------------------------------------------------
  # MEMBERS LIST CAN BE READ BY
  #-----------------------------------------------------

  def test_that_public_members_list_can_be_read_by_nil_user
    group = Group.new(:members_list_access_level => Group::ACCESS_ANYONE)
    assert group.members_list_can_be_read_by?(nil)
  end
  
  def test_that_public_members_list_can_be_read_by_unrelated_user
    group = Group.new(:members_list_access_level => Group::ACCESS_ANYONE)
    assert group.members_list_can_be_read_by?(users(:bob))
  end
  
  def test_that_members_members_list_cant_be_read_by_nil_user
    group = groups(:craigs_playground)
    group.members_list_access_level = Group::ACCESS_MEMBERS_ONLY
    assert !group.members_list_can_be_read_by?(nil)
  end
  
  def test_that_members_members_list_cant_be_read_by_unrelated_user
    group = groups(:craigs_playground)
    group.members_list_access_level = Group::ACCESS_MEMBERS_ONLY
    assert !group.members_list_can_be_read_by?(users(:bob))
  end
  
  def test_that_members_members_list_can_be_read_by_member_user
    group = groups(:craigs_playground)
    group.members_list_access_level = Group::ACCESS_MEMBERS_ONLY
    assert group.members_list_can_be_read_by?(users(:frodo))
  end
  
  def test_that_off_members_list_can_be_read_by_member_user
    group = groups(:craigs_playground)
    group.members_list_access_level = Group::ACCESS_OFF
    assert group.members_list_can_be_read_by?(users(:frodo))
  end

  #-----------------------------------------------------
  # DISPLAY NAME
  #-----------------------------------------------------

  def test_that_display_name_returns_group_name_if_name_is_blank
    assert_equal 'craigsplayground', Group.new(:group_name => 'craigsplayground', :name => '').display_name
  end
  
  def test_that_display_name_returns_name_if_specified
    assert_equal 'Craigs Playground BDSM Group Auckland', Group.new(:group_name => 'craigsplayground', :name => 'Craigs Playground BDSM Group Auckland').display_name
  end
  
  def test_that_display_name_returns_group_name_if_name_is_really_long
    assert_equal 'craigsplayground', Group.new(:group_name => 'craigsplayground', :name => 'Polite, nonjudgemental, forum for the discussion of D/s, B&D, and SM lifestyles with emphasis on the New Zealand situation.').display_name
  end

  
end
