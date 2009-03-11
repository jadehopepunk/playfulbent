require File.dirname(__FILE__) + '/../test_helper'
require 'user_locations_controller'

# Re-raise errors caught by the controller.
class UserLocatiosnController; def rescue_action(e) raise e end; end

class UserLocationsControllerTest < Test::Unit::TestCase
  fixtures :profiles, :locations, :users, :email_addresses
  
  def setup
    @controller = UserLocationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #------------------------------------------------------------------
  # UPDATE
  #------------------------------------------------------------------

  def test_that_update_requires_login
    assert_requires_login do |proxy|
      proxy.put :update, :profile_id => 'sam', :location => {'country' => 'New Zealand', 'city' => 'Auckland'}
    end
  end
  
  def test_that_update_denies_access_if_profile_cant_be_edited_by_current_user
    assert_requires_access(:frodo) do |proxy|
      proxy.put :update, :profile_id => 'sam', :location => {'country' => 'New Zealand', 'city' => 'Auckland'}
    end
  end
  
  def test_that_update_can_update_existing_location
    login_as :sam
    put :update, :profile_id => 'sam', :location => {'country' => 'New Zealand', 'city' => 'Auckland'}, :format => 'js'
    
    assert_response :success
    profile = assigns(:profile)
    assert_equal profiles(:sam), profile
    location = profile.reload.location
    assert location
    assert_equal 'New Zealand', location.country
    assert_equal 'Auckland', location.city
  end
  
  def test_that_update_can_create_new_location
    login_as :sponsoring_sam
    put :update, :profile_id => 'sponsoring_sam', :location => {'country' => 'New Zealand', 'city' => 'Auckland'}, :format => 'js'
    
    assert_response :success
    profile = assigns(:profile)
    assert_equal profiles(:no_avatar), profile
    location = profile.reload.location
    assert location
    assert_equal 'New Zealand', location.country
    assert_equal 'Auckland', location.city
  end
  
  
  
end
