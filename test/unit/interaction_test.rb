# == Schema Information
#
# Table name: interactions
#
#  id         :integer(4)      not null, primary key
#  actor_id   :integer(4)
#  subject_id :integer(4)
#  type       :string(255)
#  created_at :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class InteractionTest < Test::Unit::TestCase
  fixtures :interactions, :relationships, :users, :email_addresses, :interaction_counts

  #---------------------------------------------------------
  # MEETS CRITERIA?
  #---------------------------------------------------------
  
  def test_is_friend_of_meets_criteria
    assert InteractionIsFriendOf.meets_criteria?(users(:aaron), users(:sam))
    assert !InteractionIsFriendOf.meets_criteria?(users(:sam), users(:aaron))
  end
  
  def test_friends_with_meets_criteria
    assert !InteractionFriendsWith.meets_criteria?(users(:aaron), users(:sam))
    assert InteractionFriendsWith.meets_criteria?(users(:sam), users(:aaron))
  end

  #---------------------------------------------------------
  # CREATE
  #---------------------------------------------------------
  
  def test_that_creating_interaction_updates_interaction_count
    count = interaction_counts(:sam_with_frodo)
    assert_equal 1, count.number
    InteractionFriendsWith.ensure_created(users(:sam), users(:frodo))
    assert_equal 2, count.reload.number
  end
  
end
