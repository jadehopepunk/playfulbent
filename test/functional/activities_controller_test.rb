require File.dirname(__FILE__) + '/../test_helper'
require 'activities_controller'

# Re-raise errors caught by the controller.
class ActivitiesController; def rescue_action(e) raise e end; end

class ActivitiesControllerTest < Test::Unit::TestCase
  def setup
    @controller = ActivitiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
