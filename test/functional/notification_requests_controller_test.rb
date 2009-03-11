require File.dirname(__FILE__) + '/../unit_test_helper'
require 'notification_requests_controller'

# Re-raise errors caught by the controller.
class NotificationRequestsController; def rescue_action(e) raise e end; end

class NotificationRequestsControllerTest < Test::Unit::TestCase
  def setup
    @controller = NotificationRequestsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
