require File.dirname(__FILE__) + '/../test_helper'
require 'relationships_controller'

# Re-raise errors caught by the controller.
class RelationshipsController; def rescue_action(e) raise e end; end

class RelationshipsControllerTest < Test::Unit::TestCase
  fixtures :users, :relationships, :relationship_types
  
  def setup
    @controller = RelationshipsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_that_index_returns_success
    get :index, :user_id => '1003'
    
    assert_response :success
    assert_template 'index'
  end
  
  def test_that_index_populates_relationships_from_user
    get :index, :user_id => '11'
    
    assert_equal [[relationship_types(:pippins_friends), [relationships(:pippin_likes_frodo)]]], assigns(:relationship_types)
  end
  
  def test_that_index_populates_your_relationships_with_user
    login_as :frodo
    get :index, :user_id => '11'
    
    assert_equal relationships(:pippin_likes_frodo), assigns(:users_relationship_with_you)
    assert_equal relationships(:frodo_likes_pippin), assigns(:your_relationship_with_user)
  end

  def test_that_new_requires_login
    assert_requires_login do |proxy|
      proxy.get :new, :accepts => :js, :user_id => '1003'
    end
  end
  
  def test_that_new_returns_html
    login_as :sam
    get :new, :user_id => '1003'
        
    assert_response :success
    assert_template 'new'
  end
  
  def test_that_new_with_user_search_string_returns_users
    login_as :sam
    get :new, :user_id => '1003', :user_search_string => 'bob'
    
    assert_response :success
    assert_equal ["Bob", "Existingbob", "Longbob"], assigns(:users).map(&:name)
  end
  
  def test_that_new_with_subject_id_returns_single_user
    login_as :sam
    get :new, :user_id => '1003', :user_search_string => 'bob', :subject_id => '1002'
    
    assert_response :success
    assert_equal ["Aaron"], assigns(:users).map(&:name)
    assert_equal users(:aaron), assigns(:relationship).subject
  end

  def test_that_new_returns_javascript
    login_as :sam
    get :new, :accepts => :js, :user_id => '1003'
    assert_response :success
    assert_template 'new'
  end
  
  def test_that_create_redirects_to_index_if_valid_and_html
    login_as :sam
    post :create, 'relationship' => valid_relationship, :user_id => users(:sam).to_param
    assert_redirected_to user_relationships_path(users(:sam))
  end
  
  def test_that_create_displays_new_tempalte_if_invalid_and_html
    login_as :sam
    post :create, 'relationship' => invalid_relationship, :user_id => users(:sam).to_param
    assert_response :success
    assert_template 'new'
  end
  
  def test_that_create_requires_login
    assert_requires_login do |proxy|
      proxy.post :create, 'relationship' => valid_relationship, :user_id => users(:sam).to_param
    end
  end
  
  def test_that_create_requires_current_user_to_be_selected_user
    assert_requires_access(:sam) do |proxy|
      proxy.post :create, 'relationship' => valid_relationship, :user_id => users(:aaron).to_param
    end
  end
  
  def test_that_destroy_requires_login
    assert_requires_login do |proxy|
      proxy.delete :destroy, :user_id => users(:sam).to_param, :id => relationships(:aaron_is_sams_friend).to_param
    end
  end
  
  def test_that_destroy_requires_selected_user_to_be_editable_by_current_user
    assert_requires_access(:aaron) do |proxy|
      proxy.delete :destroy, :user_id => users(:sam).to_param, :id => relationships(:aaron_is_sams_friend).to_param
    end
  end
  
  def test_that_destroy_destroys_relationship_and_redirects_to_index
    login_as :sam
    delete :destroy, :user_id => users(:sam).to_param, :id => relationships(:aaron_is_sams_friend).to_param
    
    assert !Relationship.exists?(1)
    assert_redirected_to user_relationships_path(users(:sam))
  end

  def test_that_edit_requires_login
    assert_requires_login do |proxy|
      proxy.get :edit, :user_id => users(:sam).to_param, :id => relationships(:aaron_is_sams_friend).to_param
    end
  end
  
  def test_that_edit_requires_selected_user_to_be_editable_by_current_user
    assert_requires_access(:aaron) do |proxy|
      proxy.get :edit, :user_id => users(:sam).to_param, :id => relationships(:aaron_is_sams_friend).to_param
    end
  end
  
  def test_that_edit_displays_form
    login_as :sam
    get :edit, :user_id => users(:sam).to_param, :id => relationships(:aaron_is_sams_friend).to_param
    
    assert_response :success
    assert_template 'edit'
  end

  def test_that_update_requires_login
    assert_requires_login do |proxy|
      proxy.put :update, :user_id => users(:sam).to_param, :id => relationships(:aaron_is_sams_friend).to_param
    end
  end
  
  def test_that_update_requires_selected_user_to_be_editable_by_current_user
    assert_requires_access(:aaron) do |proxy|
      proxy.put :update, :user_id => users(:sam).to_param, :id => relationships(:aaron_is_sams_friend).to_param
    end
  end
  
  def test_that_update_updates_model_and_redirects_to_index
    login_as :sam
    put :update, :user_id => users(:sam).to_param, :id => relationships(:aaron_is_sams_friend).to_param, :relationship => valid_relationship('description' => 'eat my shorts')
    
    assert_equal 'eat my shorts', relationships(:aaron_is_sams_friend).reload.description
    assert_redirected_to user_relationships_path(users(:sam))
  end
  
  def test_that_reorder_requires_login
    assert_requires_login do |proxy|
      proxy.post :reorder, :user_id => users(:sam).to_param
    end
  end
  
  def test_that_reorder_requires_selected_user_to_be_editable_by_current_user
    assert_requires_access(:aaron) do |proxy|
      proxy.post :reorder, :user_id => users(:sam).to_param
    end
  end
  
  def test_that_reorder_changes_relationship_type_positions
    login_as :sam
    post :reorder, :user_id => users(:sam).to_param, 'relationship_types' => ['2', '1']
    
    assert_equal 2, RelationshipType.find(1).position
    assert_equal 1, RelationshipType.find(2).position
    assert_response :success
  end
  
  protected
  
    def valid_relationship(params = {})
      {'subject_id' => users(:longbob).id.to_s, 'name' => 'sister'}.merge(params)
    end
    
    def invalid_relationship
      valid_relationship 'name' => ''
    end
  
end
