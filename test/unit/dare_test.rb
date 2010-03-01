# == Schema Information
#
# Table name: dares
#
#  id                   :integer(4)      not null, primary key
#  request              :text(16777215)
#  requires_photo       :boolean(1)
#  requires_description :boolean(1)
#  created_on           :datetime
#  creator_id           :integer(4)
#  responded_to         :boolean(1)
#  expired              :boolean(1)
#

require File.dirname(__FILE__) + '/../test_helper'

class DareTest < Test::Unit::TestCase
  fixtures :dares, :users, :email_addresses

  def test_can_create_dare_if_there_are_open_slots
    Dare.stubs(:count_open).returns(Dare::MAX_OPEN - 1)
    
    dare = Dare.new(:request => 'do something', :creator => User.new)
    assert dare.valid?
  end

  def test_cant_create_dare_if_there_are_already_enough_open
    Dare.stubs(:count_open).returns(Dare::MAX_OPEN)
    
    dare = Dare.new(:request => 'do something', :creator => User.new)
    assert !dare.valid?
  end
  
  def test_owners_returns_creator_and_response_users
    user1 = User.new(:nick => 'One')
    user2 = User.new(:nick => 'Two')
    user3 = User.new(:nick => 'Three')
    
    dare = Dare.new(:creator => user1)
    dare.stubs(:responses).returns([DareResponse.new(:user => user2), DareResponse.new(:user => user3), DareResponse.new(:user => user2)])
    
    assert_equal [user1, user2, user3], dare.owners
  end
  
  def test_expire_sends_email_and_sets_expired_if_saved
    dare = dares(:banana)
    dare.expire
    NotificationsMailer.expects(:deliver_dare_expired).with(dare)

    dare.save
    
    assert_equal true, dare.expired
  end
  
  def test_expired_doesnt_send_email_if_already_expired
    dare = dares(:expired_dare)
    dare.expire
    NotificationsMailer.expects(:deliver_dare_expired).with(dare).never

    dare.save
    
    assert_equal true, dare.expired
  end
  
  def test_should_expire_false_if_created_on_less_than_three_weeks
    dare = dares(:banana)
    dare.created_on = 2.weeks.ago
    assert_equal false, dare.should_expire?
  end
  
  def test_should_expire_true_if_created_on_is_three_weeks_ago
    dare = dares(:banana)
    dare.created_on = 3.weeks.ago
    assert_equal true, dare.should_expire?
  end
  
  def test_should_expire_is_false_if_dare_is_responded_to
    dare = dares(:banana)
    dare.responded_to = true
    dare.created_on = 3.weeks.ago
    assert_equal false, dare.should_expire?
  end
  
end
