require File.dirname(__FILE__) + '/../unit_test_helper'
require 'my_photos_controller'

# Re-raise errors caught by the controller.
class MyPhotosController; def rescue_action(e) raise e end; end

class MyPhotosControllerTest < Test::Unit::TestCase
  def setup
    @controller = MyPhotosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
