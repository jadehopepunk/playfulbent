require File.dirname(__FILE__) + '/../test_helper'
require 'messages_controller'

# Re-raise errors caught by the controller.
class MessagesController; def rescue_action(e) raise e end; end

class MessagesControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :messages, :photo_sets
  
  def setup
    @controller = MessagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  #-----------------------------------------------------------
  # INDEX
  #-----------------------------------------------------------
  
  def test_index_requires_login
    assert_requires_login do |c|
      c.get :index, :user_id => '1003'
    end
  end
  
  def test_index_succeeds_if_user_is_editable_by_current_user
    login_as :sam
    get :index, :user_id => '1003'
    assert_response :success
  end
  
  def test_index_fails_if_user_is_not_editable_by_current_user
    assert_requires_access(:aaron) do |proxy|
      proxy.get :index, :user_id => '1003'
    end
  end
  
  #-----------------------------------------------------------
  # SENT
  #-----------------------------------------------------------

  def test_sent_requires_login
    assert_requires_login do |c|
      c.get :sent, :user_id => '1003'
    end
  end

  def test_sent_fails_if_user_is_not_editable_by_current_user
    assert_requires_access(:aaron) do |proxy|
      proxy.get :sent, :user_id => '1003'
    end
  end
  
  def test_sent_displays_list
    login_as :sam
    get :sent, :user_id => '1003'
    assert_response :success
  end
  
  #-----------------------------------------------------------
  # NEW
  #-----------------------------------------------------------
  
  def test_new_requires_login
    assert_requires_login do |c|
      c.get :new, :user_id => '1003'
    end
  end

  def test_new_fails_if_user_is_not_editable_by_current_user
    assert_requires_access(:aaron) do |proxy|
      proxy.get :new, :user_id => '1003'
    end
  end
  
  def test_new_succeeds_if_user_is_editable_by_current_user
    login_as :sam
    get :new, :user_id => '1003'
    assert_response :success
  end
  
  #-----------------------------------------------------------
  # CREATE
  #-----------------------------------------------------------
  
  def test_create_requires_login
    assert_requires_login do |c|
      c.post :create, :user_id => '1003'
    end
  end
  
  def test_create_fails_if_user_is_not_editable_by_current_user
    assert_requires_access(:aaron) do |proxy|
      proxy.post :create, :user_id => '1003'
    end
  end

  def test_create_redisplays_new_template_if_message_invalid
    login_as :sam
    post :create, :user_id => '1003', 'message' => invalid_message
    
    assert_response :success
    assert_template 'new'
  end
  
  def test_create_redirects_to_index_and_saves_message_if_params_valid
    login_as :sam
    post :create, :user_id => '1003', 'message' => valid_message, :format => 'html'
    
    message = assigns(:message)
    assert message
    assert !message.new_record?
    assert_equal 'hi there', message.subject
    assert_redirected_to user_messages_path(users(:sam))
  end
  
  #-----------------------------------------------------------
  # READ
  #-----------------------------------------------------------
  
  def test_read_succeeds_if_user_is_editable_by_current_user
    login_as :sam
    post :read, :user_id => '1003', :id => '1', :format => 'js'
    assert_response :success
  end
  
  def test_read_fails_if_user_is_not_editable_by_current_user
    assert_requires_access(:aaron) do |proxy|
      proxy.post :read, :user_id => '1003', :id => '1', :format => 'js'
    end
  end
  
  protected
  
    def valid_message(options = {})
      {:subject => 'hi there', :body => 'just a note to say I miss you', :recipient_id => '13'}.merge(options)
    end
    
    def invalid_message
      valid_message(:subject => '')
    end
  
end
