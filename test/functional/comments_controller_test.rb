require File.dirname(__FILE__) + '/../test_helper'
require 'comments_controller'

# Re-raise errors caught by the controller.
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < Test::Unit::TestCase
  fixtures :conversations, :comments, :users, :email_addresses

  def setup
    @controller = CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new    
  end
  
  #-------------------------------------------------------------------
  # INDEX
  #-------------------------------------------------------------------

  def test_that_index_displays_template
    get :index, :conversation_id => '1'
    assert_response :success
  end

  #-------------------------------------------------------------------
  # NEW
  #-------------------------------------------------------------------

  def test_that_new_requires_login
    assert_requires_login do |proxy|
      proxy.get :new, :conversation_id => '1'
    end
  end

  def test_that_new_displays_template
    login_as :bob
    get :new, :conversation_id => '1'
    assert_response :success
  end
  
  def test_that_new_loads_parent_if_specified
    login_as :bob
    get :new, :conversation_id => '1', :parent_id => '1'

    assert_equal comments(:one), assigns(:parent)
  end
  
  def test_that_new_puts_parent_id_in_hidden_field_if_specified
    login_as :bob
    get :new, :conversation_id => '1', :parent_id => '1'
    
    assert_select 'input[name=?]', 'parent_id'
  end

  #-------------------------------------------------------------------
  # CREATE
  #-------------------------------------------------------------------

  def test_that_create_requires_login
    assert_requires_login do |proxy|
      proxy.post :create, :conversation_id => '1'
    end
  end
  
  def test_that_create_saves_root_comment
    login_as :frodo
    post :create, :conversation_id => '1', :comment => {'content' => 'some stuff from craig'}
    
    comment = assigns(:comment)
    assert comment
    assert !comment.new_record?
    comment.reload
    assert_equal 'some stuff from craig', comment.content
    assert_equal nil, comment.parent
    assert_equal [comments(:one)], comment.previous_siblings
    assert_equal [], comment.next_siblings
  end
  
  def test_that_create_saves_child_comment
    login_as :frodo
    post :create, :conversation_id => '2', :parent_id => '2', :comment => {'content' => 'some stuff from craig'}

    comment = assigns(:comment)
    assert comment
    assert !comment.new_record?
    comment.reload
    assert_equal 'some stuff from craig', comment.content
    assert_equal comments(:two), comment.parent
    assert_equal [comments(:two_one)], comment.previous_siblings
    assert_equal [], comment.next_siblings
  end


  
end
