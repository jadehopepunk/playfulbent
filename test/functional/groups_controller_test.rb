require File.dirname(__FILE__) + '/../test_helper'
require 'groups_controller'

# Re-raise errors caught by the controller.
class GroupsController; def rescue_action(e) raise e end; end

class GroupsControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :groups
  
  def setup
    @controller = GroupsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def mock_scraper
    Yahoo::Scraper.stubs(:new).returns(Yahoo::MockScraper.new(AppConfig.yahoo_scraper_account))
  end

  #------------------------------------------------------------
  # NEW
  #------------------------------------------------------------
  
  def test_new_requires_login
    assert_requires_login do |proxy|
      proxy.get :new
    end
  end
  
  def test_new_displays_page
    login_as :admin
    get :new
    
    assert_response :success
    assert_template 'new'
  end
  
  #------------------------------------------------------------
  # CREATE
  #------------------------------------------------------------
  
  def test_create_requires_login
    mock_scraper
    
    assert_requires_login do |proxy|
      proxy.post :create
    end
  end
  
  def test_create_displays_error_if_validation_fails
    mock_scraper
    
    login_as :admin
    post :create
    
    assert_response :success
    assert_template 'new'
  end
  
  def test_create_creates_new_group_and_redirects_to_show_page_if_params_are_valid
    mock_scraper
    
    login_as :admin
    post :create, 'group' => {'group_name' => 'bi_auckland'}
    
    result = Group.find_by_group_name('bi_auckland')
    assert result
    assert_equal users(:admin), result.owner
    assert_redirected_to group_path('bi_auckland')
  end
  
end
