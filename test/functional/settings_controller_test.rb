require File.dirname(__FILE__) + '/../test_helper'
require 'settings_controller'

# Re-raise errors caught by the controller.
class SettingsController; def rescue_action(e) raise e end; end

class SettingsControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses

  def setup
    @controller = SettingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

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
  
  
end
