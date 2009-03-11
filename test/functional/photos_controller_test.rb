require File.dirname(__FILE__) + '/../test_helper'
require 'photos_controller'

# Re-raise errors caught by the controller.
class PhotosController; def rescue_action(e) raise e end; end

class PhotosControllerTest < Test::Unit::TestCase
  def setup
    @controller = PhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #-----------------------------------------------------
  # INDEX
  #-----------------------------------------------------
  
  def test_that_index_renders_template
    get :index
    
    assert_response :success
    assert_template 'index'
  end
  
end
