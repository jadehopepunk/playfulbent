require File.dirname(__FILE__) + '/../unit_test_helper'
require 'invitations_controller'

# Re-raise errors caught by the controller.
class InvitationsController; def rescue_action(e) raise e end; end

class InvitationsControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :strip_shows, :strip_photos, :invitations
  
  
  def setup
    @controller = InvitationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #---------------------------------------------------
  # SEND INVITE USER
  #---------------------------------------------------

  def test_that_send_invite_user_requires_login
    assert_requires_login do |proxy|
      proxy.post :send_invite_user, :id => strip_shows(:sams_show).id, :user_id => users(:frodo).id
    end
  end
  
  def test_that_send_invite_user_denies_access_unless_current_user_owns_strip_show
    assert_requires_access(:pippin) do |proxy|
      proxy.post :send_invite_user, :id => strip_shows(:sams_show).id, :user_id => users(:frodo).id
    end    
  end
  
  def test_that_send_invite_user_redirects_to_invited_users_stripshow_page
    login_as :sponsoring_sam
    post :send_invite_user, :id => strip_shows(:sams_show).id, :user_id => users(:frodo).id
    
    assert_redirected_to user_my_stripshows_path(users(:frodo))
  end
  
end
