require File.dirname(__FILE__) + '/../test_helper'
require 'story_subscriptions_controller'

# Re-raise errors caught by the controller.
class StorySubscriptionsController; def rescue_action(e) raise e end; end

class StorySubscriptionsControllerTest < Test::Unit::TestCase
  def setup
    @controller = StorySubscriptionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @frodo = User.new(:nick => 'frodo')
    @frodo.stubs(:new_record?).returns(false)
    @frodo.stubs(:id).returns(1)
    
    @bilbo = User.new(:nick => 'bilbo')
    @bilbo.stubs(:new_record?).returns(false)
    @frodo.stubs(:id).returns(2)
  end
  
  def load_story
    @story_47 = Story.new
    @story_47.stubs(:id).returns(47)
    Story.stubs(:find).with('47').returns(@story_47)
  end
  
  def load_frodos_subscription
    @story_subscription_12 = StorySubscription.new
    @story_subscription_12.stubs(:id).returns(12)
    @story_subscription_12.stubs(:user).returns(@frodo)
    @story_subscription_12.stubs(:can_be_modified_by).with(@frodo).returns(true)
    @story_subscription_12.stubs(:can_be_modified_by).with(@bilbo).returns(false)
    
    StorySubscription.stubs(:find).with('12', {:limit => nil, :select => nil, :group => nil, :joins => nil, :include => nil, :offset => nil, :conditions => 'story_subscriptions.story_id = 47'}).returns(@story_subscription_12)
  end

  def test_create_fails_if_story_not_found
    login_as_mock @frodo
    assert_raise(ActiveRecord::RecordNotFound) do
      post :create
    end
  end
  
  def test_create_requires_login
    load_story
    assert_requires_login do
      post :create, {:story_id => '47', :story_subscription => {:continue_page_i_wrote => '0', :continue_page_i_follow => '1'}}
    end
  end
  
  def test_create_creates_new_subscription_for_story
    load_story
    StorySubscription.expects(:create).with({:story => @story_47, :user => @frodo, 'continue_page_i_follow' => '1', 'continue_page_i_wrote' => '0'}).returns(StorySubscription.new)
  
    login_as_mock @frodo
    post :create, {:story_id => '47', :story_subscription => {:continue_page_i_wrote => '0', :continue_page_i_follow => '1'}}
  
    assert_response 200
  end
  
  def test_update_fails_if_story_not_found
    login_as_mock @frodo
    assert_raise(ActiveRecord::RecordNotFound) do
      put :update
    end
  end
  
  def test_update_requires_login
    load_story
    assert_requires_login do
      put :update, {:story_id => '47', :story_subscription => {:continue_page_i_wrote => '0', :continue_page_i_follow => '1'}}
    end
  end

  def test_update_fails_if_subscription_not_found
    load_story
    login_as_mock @frodo
    assert_raise(ActiveRecord::RecordNotFound) do
      put :update, {:story_id => '47', :story_subscription => {:continue_page_i_wrote => '0', :continue_page_i_follow => '1'}}
    end
  end

  def test_update_returns_access_denied_if_user_doesnt_own_subscription
    @story_subscription = Factory.create(:story_subscription)
    
    login_as Factory.create(:user)
    put :update, {
      :story_id => @story_subscription.story.to_param, 
      :id => @story_subscription.to_param, 
      :story_subscription => {:continue_page_i_wrote => '0', :continue_page_i_follow => '1'}}

    assert_response 401
  end
    
  def test_update_updates_the_specified_subscription
    @story_subscription = Factory.create(:story_subscription)
    
    login_as @story_subscription.user
    put :update, {
      :story_id => @story_subscription.story.to_param, 
      :id => @story_subscription.to_param, 
      :story_subscription => {:continue_page_i_wrote => '0', :continue_page_i_follow => '1'}}
  
    assert_response 200
    assert !@story_subscription.reload.continue_page_i_wrote
    assert @story_subscription.reload.continue_page_i_follow
  end
  
  
end
