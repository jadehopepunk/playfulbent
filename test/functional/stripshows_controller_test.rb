require File.dirname(__FILE__) + '/../unit_test_helper'
require 'stripshows_controller'

# Re-raise errors caught by the controller.
class StripshowsController; def rescue_action(e) raise e end; end

class StripshowsControllerTest < Test::Unit::TestCase
  fixtures :strip_shows, :strip_show_views, :users, :email_addresses, :strip_photos
  
  def setup
    @controller = StripshowsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #--------------------------------------------------------------
  # NEXT UNVIEWED
  #--------------------------------------------------------------
  
  def test_that_next_unviewed_shows_first_photo_if_none_are_viewed
    login_as :pippin
    get :next_unviewed, :id => strip_shows(:sams_show).to_param
    
    assert_redirected_to(:controller => "stripshows", :action => "view_photo", :id => strip_photos(:sam1))
  end
end
