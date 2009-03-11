require File.dirname(__FILE__) + '/../test_helper'
require 'my_blogs_controller'

# Re-raise errors caught by the controller.
class MyBlogsController; def rescue_action(e) raise e end; end

class MyBlogsControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :syndicated_blogs
  
  def setup
    @controller = MyBlogsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_new
    get :new, :user_id => 1004, :format => 'js'
    assert_response :success
  end
end
