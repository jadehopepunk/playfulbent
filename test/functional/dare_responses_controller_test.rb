require File.dirname(__FILE__) + '/../unit_test_helper'
require 'dare_responses_controller'

# Re-raise errors caught by the controller.
class DareResponsesController; def rescue_action(e) raise e end; end

class DareResponsesControllerTest < Test::Unit::TestCase
  fixtures :dares, :base_dare_responses
  
  def setup
    @controller = DareResponsesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  
  #---------------------------------------------------------
  # INDEX
  #---------------------------------------------------------
  
  def test_that_index_displays_html
    get :index
    
    assert_response :success
    assert_template 'index'
  end
  
end
