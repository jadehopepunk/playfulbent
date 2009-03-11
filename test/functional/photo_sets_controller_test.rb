require File.dirname(__FILE__) + '/../test_helper'
require 'photo_sets_controller'

# Re-raise errors caught by the controller.
class PhotoSetsController; def rescue_action(e) raise e end; end

class PhotoSetsControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :profiles, :photo_sets, :gallery_photos
  
  def setup
    @controller = PhotoSetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  ## NEW: covered by specs

  ## CREATE: covered by specs

  #----------------------------------------------------
  # EDIT
  #----------------------------------------------------

  def test_that_edit_requires_login
    assert_requires_login do |proxy|
      proxy.get :edit, :user_id => 11, :id => 1
    end
  end
  
  def test_that_edit_requires_current_user_to_own_photo_set
    assert_requires_access(:sam) do |proxy|
      proxy.get :edit, :user_id => 11, :id => 1
    end
  end
  
  def test_that_edit_displays_form
    login_as :pippin
    get :edit, :user_id => 11, :id => 1
    
    assert_response :success
  end

  #----------------------------------------------------
  # UPDATE
  #----------------------------------------------------

  def test_that_update_requires_login
    assert_requires_login do |proxy|
      proxy.put :update, :user_id => 11, :id => 1
    end
  end
  
  def test_that_update_requires_current_user_to_own_photo_set
    assert_requires_access(:sam) do |proxy|
      proxy.put :update, :user_id => 11, :id => 1
    end
  end
  
  def test_that_update_with_invalid_values_displays_edit_template
    login_as :pippin
    put :update, :user_id => 11, :photo_set => invalid_photo_set, :id => 1
    
    assert_response :success
    assert_template 'edit'
  end
  
  def test_that_update_creates_photo_set_and_redirects_photo_index
    login_as :pippin
    put :update, :user_id => 11, :photo_set => valid_photo_set, :id => 1
    
    photo_set = assigns(:photo_set)
    assert photo_set
    assert photo_set.reload
    assert_equal 'Naked Shots', photo_set.title
    
    assert_redirected_to user_photo_set_path(users(:pippin), photo_set)
  end
  
  def test_that_update_deletes_cache_if_not_set_to_viewable_by_everyone
    FileUtils.expects(:rm_rf).with("#{RAILS_ROOT}/public/photo_sets/3/photos")
    
    login_as :sam
    put :update, :user_id => 1003, :photo_set => {'viewable_by' => 'friends'}, :id => 3
  end

  def test_that_update_doest_delete_cache_if_set_to_viewable_by_everyone
    FileUtils.expects(:rm_rf).never
    
    login_as :sam
    put :update, :user_id => 1003, :photo_set => {'viewable_by' => 'everyone'}, :id => 3
  end

  protected
  
    def valid_photo_set
      {'title' => 'Naked Shots'}
    end
  
    def invalid_photo_set
      {'title' => ''}
    end
  
end
