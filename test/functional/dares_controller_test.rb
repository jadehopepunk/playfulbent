require File.dirname(__FILE__) + '/../unit_test_helper'
require 'dares_controller'

# Re-raise errors caught by the controller.
class DaresController; def rescue_action(e) raise e end; end

class DaresControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :dares, :conversations, :comments
  
  def setup
    @controller = DaresController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @bilbo = User.new
    @bilbo.stubs(:new_record?).returns(false)
    
    @frodo = User.new
    
    @dare = Dare.new
    @dare.stubs(:id).returns('52')
    @dare.stubs(:creator).returns(@frodo)
    
    @conversation = Conversation.new
    @conversation.stubs(:id).returns('3')
    @conversation.stubs(:new_record?).returns(false)
  end
  
  #----------------------------------------------------------
  # NEW
  #----------------------------------------------------------

  def test_that_new_requires_login
    assert_requires_login do |proxy|
      proxy.get :new
    end
  end
  
  def test_that_new_displays_template
    login_as :frodo
    get :new
    
    assert_response :success
    assert_template 'new'
  end
  
  #----------------------------------------------------------
  # CREATE
  #----------------------------------------------------------

  def test_that_create_requires_login
    assert_requires_login do |proxy|
      proxy.post :create
    end
  end
  
  #----------------------------------------------------------
  # SHOW
  #----------------------------------------------------------

  def test_show_returns_success
    login_as :sam
    Dare.stubs(:find).with('52').returns(@dare)
    get :show, {:id => '52'}
    assert_response :success
  end

  
end
