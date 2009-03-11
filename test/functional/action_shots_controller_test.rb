require File.dirname(__FILE__) + '/../test_helper'
require 'action_shots_controller'

# Re-raise errors caught by the controller.
class ActionShotsController; def rescue_action(e) raise e end; end

class ActionShotsControllerTest < Test::Unit::TestCase
  fixtures :reviews, :action_shots, :users, :email_addresses
  
  def setup
    @controller = ActionShotsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #------------------------------------------------------------
  # NEW
  #------------------------------------------------------------
  
  def test_that_new_displays_page
    get :new, :review_id => '1'
    
    assert_response :success
    assert_template 'new'
  end
  
  #------------------------------------------------------------
  # CREATE
  #------------------------------------------------------------
  
  def test_that_create_requires_login
    assert_requires_login do |proxy|
      proxy.post :create, :review_id => '1'
    end
  end
  
  def test_that_create_requires_you_to_own_review
    assert_requires_access(:frodo) do |proxy|
      proxy.post :create, :review_id => '1'
    end
  end

  #------------------------------------------------------------
  # DESTROY
  #------------------------------------------------------------
  
  def test_that_destroy_requires_login
    assert_requires_login do |proxy|
      proxy.delete :destroy, :review_id => '1', :id => '*'
    end
  end

  def test_that_destroy_requires_you_to_own_review
    assert_requires_access(:frodo) do |proxy|
      proxy.delete :destroy, :review_id => '1', :id => '*'
    end
  end
  

  
end
