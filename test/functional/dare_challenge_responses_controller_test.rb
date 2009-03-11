require File.dirname(__FILE__) + '/../test_helper'
require 'dare_challenge_responses_controller'

# Re-raise errors caught by the controller.
class DareChallengeResponsesController; def rescue_action(e) raise e end; end

class DareChallengeResponsesControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :dare_challenges, :genders, :base_dare_responses
  
  def setup
    @controller = DareChallengeResponsesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #-----------------------------------------------------------
  # CREATE
  #-----------------------------------------------------------

  def test_that_create_requires_login
    assert_requires_login do |proxy|
      proxy.post :create, :dare_challenge_id => 4
    end
  end
  
  def test_that_create_denies_access_if_user_isnt_in_dare_challenge
    assert_requires_access(:aaron) do |proxy|
      proxy.post :create, :dare_challenge_id => 4
    end
  end
  
  def test_that_create_with_invalid_params_redisplays_form
    login_as :frodo
    post :create, :dare_challenge_id => 4, :dare_challenge_response => {}
    
    assert_response :success
    assert_template 'awaiting_your_dare_response'
  end
    
end
