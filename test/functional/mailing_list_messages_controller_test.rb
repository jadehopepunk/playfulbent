require File.dirname(__FILE__) + '/../test_helper'
require 'mailing_list_messages_controller'

# Re-raise errors caught by the controller.
class MailingListMessagesController; def rescue_action(e) raise e end; end

class MailingListMessagesControllerTest < Test::Unit::TestCase
  fixtures :groups, :mailing_list_messages, :group_memberships, :yahoo_profiles, :users, :email_addresses
  
  def setup
    @controller = MailingListMessagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #--------------------------------------------------------------
  # INDEX
  #--------------------------------------------------------------

  def test_that_index_displays_threads
    get :index, :group_id => groups(:craigs_playground).to_param
    
    assert_response :success
    assert_template 'index'
    assert_equal [mailing_list_messages(:craigs_playground_first)], assigns(:root_messages)
  end
  
  def test_that_index_displays_no_access_if_current_user_cant_access
    group = groups(:craigs_playground)
    Group.stubs(:find_by_param).with(group.to_param).returns(group)
    group.stubs(:mailing_list_can_be_read_by?).with(users(:bob)).returns(false)
    
    login_as :bob
    get :index, :group_id => group.to_param
    
    assert_response :success
    assert_equal nil, assigns(:root_messages)
    assert_template 'mailing_list_messages/no_access.html.erb'
  end

  #--------------------------------------------------------------
  # SHOW
  #--------------------------------------------------------------

  def test_that_show_displays_message
    get :show, :group_id => groups(:craigs_playground).to_param, :id => 1
    
    assert_response :success
    assert_template 'show'
    assert_equal mailing_list_messages(:craigs_playground_first), assigns(:message)
  end
  
  def test_that_show_displays_no_access_if_current_user_cant_access
    group = groups(:craigs_playground)
    Group.stubs(:find_by_param).with(group.to_param).returns(group)
    group.stubs(:mailing_list_can_be_read_by?).with(users(:bob)).returns(false)

    login_as :bob
    get :show, :group_id => groups(:craigs_playground).to_param, :id => 1
    
    assert_response :success
    assert_template 'mailing_list_messages/no_access.html.erb'
    assert_equal nil, assigns(:message)
  end
  
end
