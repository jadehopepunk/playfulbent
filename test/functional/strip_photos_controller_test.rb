require File.dirname(__FILE__) + '/../test_helper'
require 'strip_photos_controller'

# Re-raise errors caught by the controller.
class StripPhotosController; def rescue_action(e) raise e end; end

class StripPhotosControllerTest < Test::Unit::TestCase
  def setup
    @controller = StripPhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
