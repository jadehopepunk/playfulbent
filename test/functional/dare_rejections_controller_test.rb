require File.dirname(__FILE__) + '/../test_helper'
require 'dare_rejections_controller'

# Re-raise errors caught by the controller.
class DareRejectionsController; def rescue_action(e) raise e end; end

class DareRejectionsControllerTest < Test::Unit::TestCase
  fixtures :dare_challenges, :users, :email_addresses
  
  def setup
    @controller = DareRejectionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #--------------------------------------------------------------------
  # NEW
  #--------------------------------------------------------------------

  def test_that_new_requires_login
    assert_requires_login do |proxy|
      proxy.get :new, :dare_challenge_id => 4
    end
  end
  
  def test_that_new_displays_template
    login_as :frodo
    get :new, :dare_challenge_id => 4
    
    assert_response :success    
  end
  
  #--------------------------------------------------------------------
  # CREATE
  #--------------------------------------------------------------------

  def test_that_create_requires_login
    assert_requires_login do |proxy|
      proxy.post :create, :dare_challenge_id => 4
    end
  end
  
  def test_that_create_saves_rejection_reason_and_redirects_to_dare_challenge
    login_as :frodo
    post :create, :dare_challenge_id => 4, :dare_rejection => {'rejection_reason_text', "I feel uncomfortable around mimes"}
    
    assert_redirected_to dare_challenge_path(4)
    
    dare_rejection = assigns(:dare_rejection)
    assert dare_rejection
    assert !dare_rejection.new_record?
    dare_rejection = dare_rejection.reload
    
    assert_equal 'I feel uncomfortable around mimes', dare_rejection.rejection_reason_text
    assert_equal 'Frodo', dare_rejection.user.name
    assert_equal 'Show me your feet.', dare_rejection.rejected_dare_text
    assert_equal dare_challenges(:sam_challenges_frodo_with_dares), dare_rejection.dare_challenge
  end
  
end
