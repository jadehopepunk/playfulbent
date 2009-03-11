require File.dirname(__FILE__) + '/../test_helper'
require 'my_dares_controller'

# Re-raise errors caught by the controller.
class MyDaresController; def rescue_action(e) raise e end; end

class MtDaresControllerTest < Test::Unit::TestCase
  def setup
    @controller = MyDaresController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
