require File.dirname(__FILE__) + '/../test_helper'

class StorySubscriptionTest < Test::Unit::TestCase
  fixtures :story_subscriptions

  def test_requries_story_and_user
    subscription = StorySubscription.new
    assert_equal false, subscription.valid?
    assert_not_nil subscription.errors[:user_id]
    assert_not_nil subscription.errors[:story_id]
  end
  
  def test_continue_page_i_wrote_defaults_to_true
    assert_equal true, StorySubscription.new.continue_page_i_wrote
  end
  
  def test_continue_page_i_follow_defaults_to_false
    assert_equal false, StorySubscription.new.continue_page_i_follow
  end
  
  def test_can_be_modified_by_user_that_equals_subscription_user
    subscription = StorySubscription.new
    user = User.new(:nick => 'fred')
    subscription.user = user
    assert subscription.can_be_modified_by(user)
  end
  
  def test_cant_be_modified_by_user_that_doesnt_equal_subscription_user
    subscription = StorySubscription.new
    user = User.new(:nick => 'fred')
    subscription.user = user
    assert_equal false, subscription.can_be_modified_by(User.new(:nick => 'wilma'))
  end 
  
  def test_cant_be_modified_if_doesnt_have_user
    subscription = StorySubscription.new
    assert_equal false, subscription.can_be_modified_by(nil)
  end
 
end
