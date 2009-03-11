require File.dirname(__FILE__) + '/../test_helper'
require 'product_urls_controller'

# Re-raise errors caught by the controller.
class ProductUrlsController; def rescue_action(e) raise e end; end

class ProductUrlsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ProductUrlsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
