require File.dirname(__FILE__) + '/../test_helper'
require 'crushes_controller'

# Re-raise errors caught by the controller.
class CrushesController; def rescue_action(e) raise e end; end

class CrushesControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :crushes
  
  def setup
    @controller = CrushesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #----------------------------------------------------------
  # NEW
  #----------------------------------------------------------
  
  def test_that_new_displays_template
    login_as :frodo
    get :new, :subject_id => '11'
    
    assert_response :success
    assert_template 'new'
    assert assigns(:crush)
    assert_equal users(:pippin), assigns(:crush).subject
  end

  #----------------------------------------------------------
  # CREATE
  #----------------------------------------------------------
  
  def test_that_create_requires_login
    assert_requires_login do |proxy|
      proxy.post :create, :subject_id => '1003'
    end
  end
    
  def test_that_create_with_invalid_params_displays_edit_form
    login_as :frodo
    post :create, :subject_id => '1003'
    
    assert_response :success
    assert_template 'new'
  end
  
  def test_that_create_with_valid_params_creates_crush
    login_as :frodo
    post :create, :subject_id => '1003', :crush => {:fantasy => 'I like to move it move it.'}
    
    crush = assigns(:crush)
    assert crush
    assert !crush.new_record?, "Crush shouldnt be a new record"
    assert_equal 'I like to move it move it.', crush.fantasy
    assert_equal users(:frodo), crush.user
    assert_equal users(:sam), crush.subject
    
    assert_redirected_to crush_path(crush)
  end
  
  def test_that_create_cant_change_user_id_or_subject_id
    login_as :frodo
    post :create, :subject_id => '1003', :crush => {:fantasy => 'I like to move it move it.', :user_id => '1002', :subject_id => '1001'}

    crush = assigns(:crush)
    assert_equal users(:frodo), crush.user
    assert_equal users(:sam), crush.subject
  end
  
  #----------------------------------------------------------
  # INDEX
  #----------------------------------------------------------
  
  def test_that_index_requires_admin
    assert_requires_access(:frodo) do |proxy|
      proxy.get :index
    end
  end
  
  #----------------------------------------------------------
  # SHOW
  #----------------------------------------------------------
  
  def test_that_show_requires_login
    assert_requires_login do |proxy|
      proxy.get :show, :id => '1'
    end
  end
  
  def test_that_show_displays_crush
    login_as :pippin
    get :show, :id => 1
    
    assert_response :success
    assert_template 'show'
    assert_equal crushes(:pippin_likes_frodo), assigns(:crush)
  end
  
  def test_that_show_displays_reciprocated_crush
    login_as :aaron
    get :show, :id => 3
    
    
    assert_response :success
    assert_template 'show_reciprocated'
    assert_equal crushes(:aaron_likes_quentin), assigns(:crush)
    assert_equal crushes(:quentin_likes_aaron), assigns(:reciprocal_crush)
  end
  
  def test_that_show_doesnt_find_crush_that_isnt_yours
    login_as :frodo
    
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :id => 1
    end
  end
    
  #----------------------------------------------------------
  # EDIT
  #----------------------------------------------------------
  
  def test_that_edit_requires_login
    assert_requires_login do |proxy|
      proxy.get :edit, :id => '1'
    end
  end
  
  def test_that_edit_doesnt_find_crush_that_isnt_yours
    login_as :frodo
    
    assert_raises(ActiveRecord::RecordNotFound) do
      get :edit, :id => 1
    end
  end

  def test_that_edit_displays_crush_form
    login_as :pippin
    get :edit, :id => 1
    
    assert_response :success
    assert_template 'edit'
    assert_equal crushes(:pippin_likes_frodo), assigns(:crush)
  end

  #----------------------------------------------------------
  # UPDATE
  #----------------------------------------------------------
  
  def test_that_update_requires_login
    assert_requires_login do |proxy|
      proxy.put :update, :id => '1'
    end
  end
  
  def test_that_update_doesnt_find_crush_that_isnt_yours
    login_as :frodo
    
    assert_raises(ActiveRecord::RecordNotFound) do
      put :update, :id => 1
    end
  end

  def test_that_update_changes_crush_details
    login_as :pippin
    put :update, :id => 1, :crush => {'fantasy' => 'kiss your nose'}
    
    crush = assigns(:crush)
    assert crush
    assert crush.valid?
    assert_equal 'kiss your nose', crush.reload.fantasy

    assert_redirected_to crush_url(crush)
  end
  
  def test_that_update_displays_edit_form_if_details_invalid
    login_as :pippin
    put :update, :id => 1, :crush => {'fantasy' => ''}
    
    assert_response :success
    assert_template 'edit'
  end

  def test_that_update_cant_change_user_id_or_subject_id
    login_as :pippin
    put :update, :id => 1, :crush => {'fantasy' => 'kiss your nose', :user_id => '1002', :subject_id => '1001'}
    
    crush = assigns(:crush)
    assert_equal users(:pippin), crush.reload.user
    assert_equal users(:frodo), crush.reload.subject
  end
  
  #----------------------------------------------------------
  # DESTROY
  #----------------------------------------------------------
  
  def test_that_destroy_requires_login
    assert_requires_login do |proxy|
      proxy.delete :destroy, :id => '1'
    end
  end
  
  def test_that_destroy_doesnt_find_crush_that_isnt_yours
    login_as :frodo
    
    assert_raises(ActiveRecord::RecordNotFound) do
      delete :destroy, :id => 1
    end
  end
  
  def test_that_destroy_removes_crush_and_redirects_to_their_profile
    login_as :pippin
    delete :destroy, :id => 1
    
    assert !Crush.exists?(1)
    assert_redirected_to users(:frodo).profile_url
  end
  
end
