require File.dirname(__FILE__) + '/../unit_test_helper'
require 'avatars_controller'

# Re-raise errors caught by the controller.
class AvatarsController; def rescue_action(e) raise e end; end

class AvatarsControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :profiles, :avatars
  
  def setup
    @controller = AvatarsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @profile = profiles(:sam)
    Profile.stubs(:find_by_param).with('sam').returns(@profile)
  end
  
  #------------------------------------------------------
  # CREATE
  #------------------------------------------------------
  
  def test_create_requires_login
    assert_requires_login do
      post :create, {:profile_id => 'sam'}, {}
    end
  end
  
  def test_create_returns_permission_denied_if_viewing_user_doesnt_own_profile
    assert_requires_login(:frodo) do
      put :create, {:profile_id => 'sam'}
    end
  end
  
  def test_create_creates_new_avatar
    @profile.expects(:avatar_image=).with('banana')
    
    login_as :sam
    put :create, {:profile_id => 'sam', :avatar => {'image' => 'banana'}}
  end
  
end
