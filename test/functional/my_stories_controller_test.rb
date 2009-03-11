require File.dirname(__FILE__) + '/../test_helper'
require 'my_stories_controller'

# Re-raise errors caught by the controller.
class MStoriesController; def rescue_action(e) raise e end; end

class MyStoriesControllerTest < Test::Unit::TestCase
  def setup
    @controller = MyStoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
