require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :profiles
  
  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #----------------------------------------------------
  # CREATE  
  #----------------------------------------------------
  
  def test_that_create_replaces_form_if_user_is_invalid
    post :create, :user => {}, :format => 'js'
    
    assert_response :success
    assert_select_rjs :replace, 'signup_form'
  end
  
  def test_that_create_saves_new_user
    post :create, :user => valid_user_params, :format => 'js'
    
    assert_response :success
    
    user = assigns(:user)
    assert user
    assert !user.new_record?
  end
  
  def test_that_signup_can_populate_dummy
    post :create, :user => valid_user_params(:email => 'dummy2@craigambrose.com'), :format => 'js'
    
    assert !assigns(:user).new_record?
    assert assigns(:user).valid?
  end
  
  protected
  
    def valid_user_params(options = {})
      {:nick => 'newcraig', :password => 'password', :password_confirmation => 'password', :email => 'newcraig@craigambrose.com'}.merge(options)
    end
  
end
