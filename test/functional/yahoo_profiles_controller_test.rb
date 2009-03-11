require File.dirname(__FILE__) + '/../test_helper'
require 'yahoo_profiles_controller'

# Re-raise errors caught by the controller.
class YahooProfilesController; def rescue_action(e) raise e end; end

class YahooProfilesControllerTest < Test::Unit::TestCase
  fixtures :yahoo_profiles, :users, :email_addresses
  
  def setup
    @controller = YahooProfilesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @scraper = Yahoo::MockScraper.new(AppConfig.yahoo_scraper_account)
    Yahoo::Scraper.stubs(:new).returns(@scraper)
  end
  
  #-------------------------------------------------------------
  # SHOW
  #-------------------------------------------------------------

  def test_that_show_loads_profile_page
    get :show, :id => yahoo_profiles(:emlyn).to_param
    
    assert_response :success
    assert_template 'show'
    assert_equal yahoo_profiles(:emlyn), assigns(:yahoo_profile)
  end
  
  def test_that_show_redirects_to_user_profile_page_if_profile_is_claimed
    get :show, :id => yahoo_profiles(:frodo).to_param
    
    assert_redirected_to 'http://frodo.playfulbent.com'
  end

  #-------------------------------------------------------------
  # CLAIM
  #-------------------------------------------------------------

  def test_that_claim_requires_login
    assert_requires_login do |proxy|
      proxy.post :claim, :id => yahoo_profiles(:emlyn).to_param
    end
  end

  def test_that_claim_with_invalid_password_sets_flash_and_redirects_to_show
    @scraper.stubs(:check_login).with('emlyn23', 'stuff').returns(false)
    
    login_as :frodo
    post :claim, :id => yahoo_profiles(:emlyn).to_param, :password => 'stuff'
    
    assert_equal YahooProfilesController::INVALID_PASSWORD_ERROR, flash[:claim_profile_error]
    assert_redirected_to :controller => 'yahoo_profiles', :action => 'show', :id => yahoo_profiles(:emlyn).to_param
  end
  
  def test_that_claim_with_no_password_sets_flash_and_redirects_to_show
    @scraper.expects(:check_login).never
    
    login_as :frodo
    post :claim, :id => yahoo_profiles(:emlyn).to_param, :password => ''
    
    assert_equal YahooProfilesController::INVALID_PASSWORD_ERROR, flash[:claim_profile_error]
    assert_redirected_to :controller => 'yahoo_profiles', :action => 'show', :id => yahoo_profiles(:emlyn).to_param
  end
  
  def test_that_claim_with_valid_password_sets_user_id_for_profile_and_displays_success_page
    @scraper.stubs(:check_login).with('emlyn23', 'pumpkin').returns(true)
    
    login_as :frodo
    post :claim, :id => yahoo_profiles(:emlyn).to_param, :password => 'pumpkin'
    
    assert_equal nil, flash[:claim_profile_error]
    assert_equal users(:frodo), yahoo_profiles(:emlyn).reload.user
    assert_response :success
    assert_template 'claim'
  end
  
  def test_that_you_cant_claim_a_profile_that_has_already_been_claimed
    @scraper.stubs(:check_login).with('frodo', 'pumpkin').returns(true)
    
    login_as :sam
    post :claim, :id => yahoo_profiles(:frodo).to_param, :password => 'pumpkin'
    
    assert_equal users(:frodo), yahoo_profiles(:frodo).reload.user
    assert_redirected_to :controller => 'yahoo_profiles', :action => 'show', :id => yahoo_profiles(:frodo).to_param
  end
  
end
