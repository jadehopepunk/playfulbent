require File.dirname(__FILE__) + '/../test_helper'
require 'conversations_controller'

# Re-raise errors caught by the controller.
class ConversationsController; def rescue_action(e) raise e end; end

class ConversationsControllerTest < Test::Unit::TestCase
  fixtures :conversations, :users, :email_addresses, :profiles, :comments

  def setup
    @controller = ConversationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:conversations)
  end

  def test_should_get_new
    login_as :bob
    get :new, {}
    assert_response :success
  end
  
  def test_should_create_conversation
    login_as :bob
    old_count = Conversation.count
    post :create, {:conversation => { :title_override => 'fish', :comment_text => 'I like the little little duckies in the pond' }}
    assert_equal old_count+1, Conversation.count
    
    assert_redirected_to conversation_comments_path(assigns(:conversation))
  end
  
  def test_attempt_create_conversation_for_subject_that_already_has_conversation
    login_as :bob
    post :create, {:conversation => { :comment_text => 'valid text', :subject_id => '1', :subject_type => 'Profile' }}
    assert_redirected_to conversation_comments_path(assigns(:conversation))    
  end

end
