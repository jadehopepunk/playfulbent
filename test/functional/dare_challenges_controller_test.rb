require File.dirname(__FILE__) + '/../test_helper'
require 'dare_challenges_controller'

# Re-raise errors caught by the controller.
class DareChallengesController; def rescue_action(e) raise e end; end

class DareChallengesControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :dare_challenges, :profiles, :genders
  
  def setup
    @controller = DareChallengesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #-------------------------------------------------------
  # NEW
  #-------------------------------------------------------
  
  def test_new_doesnt_require_login
    get :new
    
    assert_response :success
    assert_template 'new_without_subject'
  end
  
  def test_that_new_displays_template
    login_as :frodo
    get :new, :subject_id => '11'
    
    assert_response :success
    assert_template 'new'
    assert assigns(:dare_challenge)
    assert_equal users(:pippin), assigns(:dare_challenge).subject
    assert_equal users(:frodo), assigns(:dare_challenge).user
    assert_select '.dare_challenge_form'
  end

  #-------------------------------------------------------
  # POSSIBLE SUBJECTS
  #-------------------------------------------------------

  def test_that_possible_subjects_doesnt_require_login
    get :possible_subjects, :format => 'js'
    
    assert_response :success
  end
  
  #-------------------------------------------------------
  # CREATE
  #-------------------------------------------------------
  
  def test_create_requires_login
    assert_requires_login do |proxy|
      proxy.post :create, :dare_challenge => {'subject_id' => '11'}
    end
  end
  
  def test_that_create_redisplays_new_form_if_validation_fails
    dare_challenge = DareChallenge.new({'subject_id' => '11'})
    DareChallenge.expects(:new).with({'subject_id' => '11'}).returns(dare_challenge)
    dare_challenge.expects(:save).returns(false)
    
    login_as :frodo
    post :create, :dare_challenge => {'subject_id' => '11'}
    
    assert_response :success
    assert_template 'new'
  end
  
  def test_that_create_saves_dare_change_and_redirects_to_show
    login_as :frodo
    post :create, :dare_challenge => {'subject_id' => '11'}
    
    dare_challenge = assigns(:dare_challenge)
    assert dare_challenge
    assert_redirected_to dare_challenge_path(dare_challenge)
  end
  
  def test_that_create_works_with_email_instead_of_subject
    login_as :frodo
    post :create, :dare_challenge => {'subject_id' => ''}, :email => 'somenewemail@craigambrose.com'
    
    dare_challenge = assigns(:dare_challenge).reload
    assert dare_challenge
    assert dare_challenge.subject
    assert_equal 'somenewemail@craigambrose.com', dare_challenge.subject.email
    assert dare_challenge.subject.dummy?
    assert !dare_challenge.subject.new_record?
    assert_redirected_to dare_challenge_path(dare_challenge)
  end
  
  #-------------------------------------------------------
  # SHOW
  #-------------------------------------------------------
  
  def test_show_requires_login
    assert_requires_login do |proxy|
      proxy.get :show, :id => 1
    end
  end
  
  def test_that_show_doesnt_display_page_for_another_user
    assert_requires_access(:aaron) do |proxy|
      proxy.get :show, :id => 1
    end
  end

  def test_that_show_displays_page_for_dare_challenge_user
    login_as :sam
    get :show, :id => 1
    
    assert_response :success
    assert_template 'waiting_for_subject_response'
  end
  
  def test_that_show_displays_page_for_dare_challenge_subject
    login_as :frodo
    get :show, :id => 1
    
    assert_response :success
    assert_template 'let_subject_respond'
  end
  
  def test_that_show_displays_waiting_for_user_dare_if_user_is_subject_and_has_responsed
    login_as :frodo
    put :show, :id => 2

    assert_response :success
    assert_template 'waiting_for_user_dare'
  end
  
  def test_that_show_displays_rejected_dare
    login_as :frodo
    put :show, :id => 3

    assert_response :success
    assert_template 'rejected_dare'
  end
  
  def test_that_show_asks_for_user_dare_if_subject_has_responded
    login_as :sam
    put :show, :id => 2

    assert_response :success
    assert_template 'let_user_respond'
  end
  
  #-------------------------------------------------------
  # UPDATE
  #-------------------------------------------------------
  
  def test_that_update_requires_login
    assert_requires_login do |proxy|
      proxy.put :update, :id => 1
    end
  end
  
  def test_that_update_doesnt_work_for_unrelated_user
    assert_requires_access(:aaron) do |proxy|
      proxy.put :update, :id => 1
    end
  end
  
  def test_that_update_as_responder_requires_dare_level_and_subject_dare
    login_as :frodo
    put :update, :id => 1, :dare_challenge => {'subject_dare_text' => ''}
    
    assert_response :success
    assert_template 'let_subject_respond'
    
    dare_challenge = assigns(:dare_challenge)
    assert dare_challenge
    assert dare_challenge.errors.on(:subject_dare_text)
  end
  
  def test_that_update_as_responder_saves_challenge
    login_as :frodo
    put :update, :id => 1, :dare_challenge => {'subject_dare_text' => 'eat my shorts'}
    
    dare_challenge = assigns(:dare_challenge)
    assert dare_challenge
    assert_equal 'flirty', dare_challenge.dare_level
    assert_equal 'eat my shorts', dare_challenge.subject_dare_text
    
    assert_redirected_to dare_challenge_path(dare_challenge)
  end
  
  def test_that_update_as_user_returns_error_if_no_response_yet
    assert_requires_access(:sam) do |proxy|
      proxy.put :update, :id => 1, :dare_challenge => {'user_dare_text' => 'eat my socks'}
    end
  end
  
  def test_that_update_as_user_requires_user_dare_text
    login_as :sam
    put :update, :id => 2, :dare_challenge => {'user_dare_text' => ''}

    assert_response :success
    assert_template 'let_user_respond'
    
    dare_challenge = assigns(:dare_challenge)
    assert dare_challenge
    assert dare_challenge.errors.on(:user_dare_text)
  end

  #-------------------------------------------------------
  # REJECT
  #-------------------------------------------------------
  
  def test_that_reject_requires_login
    assert_requires_login do |proxy|
      proxy.delete :reject, :id => 1
    end    
  end
  
  def test_that_reject_doesnt_work_for_unrelated_user
    assert_requires_access(:aaron) do |proxy|
      proxy.delete :reject, :id => 1
    end
  end
  
  def test_that_reject_sets_rejected_at_and_redirects_to_show
    login_as :frodo
    delete :reject, :id => 1
    
    dare_challenge = assigns(:dare_challenge)
    assert dare_challenge
    assert dare_challenge.reload.rejected_at
    
    assert_redirected_to dare_challenge_path(dare_challenge)
  end
      
end
