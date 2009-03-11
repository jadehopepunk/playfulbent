require File.dirname(__FILE__) + '/../test_helper'
require 'group_members_controller'

# Re-raise errors caught by the controller.
class GroupMembersController; def rescue_action(e) raise e end; end

class GroupMembersControllerTest < Test::Unit::TestCase
  fixtures :groups, :group_memberships, :yahoo_profiles, :users, :email_addresses
  
  def setup
    @controller = GroupMembersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @craigs_playground = groups(:craigs_playground)
  end

  #-------------------------------------------------------------------
  # INDEX
  #-------------------------------------------------------------------

  def test_that_index_displays_members
    get :index, :group_id => groups(:craigs_playground).to_param
    
    assert_response :success
    assert_template 'index'
  end
  
  def test_that_index_displays_no_access_if_current_user_cant_access
    group = groups(:craigs_playground)
    Group.stubs(:find_by_param).with(group.to_param).returns(group)
    group.stubs(:members_list_can_be_read_by?).with(users(:bob)).returns(false)
    
    login_as :bob
    get :index, :group_id => group.to_param
    
    assert_response :success
    assert_template 'group_members/no_access.html.erb'
  end
  
  #-------------------------------------------------------------------
  # CREATE
  #-------------------------------------------------------------------

  def test_that_create_requires_login
    assert_requires_login do |proxy|
      proxy.post :create, :group_id => groups(:craigs_playground).to_param, :group_membership => {'username' => 'frank', 'password' => 'bozo'}
    end
  end
    
  
end
