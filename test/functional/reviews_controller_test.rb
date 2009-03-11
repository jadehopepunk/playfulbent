require File.dirname(__FILE__) + '/../test_helper'
require 'reviews_controller'

# Re-raise errors caught by the controller.
class ReviewsController; def rescue_action(e) raise e end; end

class ReviewsControllerTest < Test::Unit::TestCase
  fixtures :products, :reviews, :users, :email_addresses
  
  def setup
    @controller = ReviewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #--------------------------------------------------
  # NEW
  #--------------------------------------------------
  
  def test_that_new_displays_template
    get :new, :product_id => '1'
    
    assert_response :success
    assert_template 'new'
  end

  #--------------------------------------------------
  # CREATE
  #--------------------------------------------------

  def test_that_create_requires_login
    assert_requires_login do |proxy|
      proxy.post :create, :product_id => '1', 'review' => valid_review
    end
  end
  
  def test_that_create_loads_new_form_if_review_is_invalid
    login_as :frodo
    post :create, :product_id => '2', 'review' => invalid_review
    
    assert_response :success
    assert_template 'new'
  end
  
  def test_that_that_create_redirects_to_show_if_review_is_valid
    login_as :frodo
    post :create, :product_id => '2', 'review' => valid_review
    
    review = assigns(:review)
    assert review
    assert !review.new_record?
    assert_redirected_to review_path(review)
  end
  
  def test_that_create_sex_toy_redirects_to_new_action_shot
    login_as :frodo
    post :create, :product_id => '1', 'review' => valid_review
    
    review = assigns(:review)
    assert_redirected_to new_review_action_shot_path(review)
  end

  #--------------------------------------------------
  # SHOW
  #--------------------------------------------------

  def test_that_show_displays_template
    get :show, :id => '1'
    
    assert assigns(:review)
    assert_response :success
    assert_template 'show'
    assert_select 'title', "Sam reviews the DVice Giantess Silicone Rubber Dildo | Playful Bent"
  end

  #--------------------------------------------------
  # EDIT
  #--------------------------------------------------
  
  def test_that_edit_requires_login
    assert_requires_login do |proxy|
      proxy.get :edit, :id => '1'
    end
  end
  
  def test_that_edit_requires_user_to_own_review
    assert_requires_access(:frodo) do |proxy|
      proxy.get :edit, :id => '1'
    end
  end
  
  def test_that_edit_displays_form
    login_as :sam
    get :edit, :id => '1'
    
    assert_response :success
  end

  #--------------------------------------------------
  # UPDATE
  #--------------------------------------------------

  def test_that_update_requires_login
    assert_requires_login do |proxy|
      proxy.put :update, :id => '1'
    end
  end
  
  def test_that_update_requires_user_to_own_review
    assert_requires_access(:frodo) do |proxy|
      proxy.put :update, :id => '1'
    end
  end
  
  def test_that_update_displays_form_if_validation_fails
    login_as :sam
    put :update, :id => '1', :review => invalid_review
    
    assert_response :success
    assert_template 'edit'
  end
  
  def test_that_update_saves_review_and_redirects_to_show
    login_as :sam
    put :update, :id => '1', :review => {'body' => 'bananafish'}
    
    assert_equal '<p>bananafish</p>', reviews(:sam_reviews_giantess).reload.body
    assert_redirected_to review_path(reviews(:sam_reviews_giantess))
  end
  

  protected
  
    def valid_review(options = {})
      {:overall_rating => '3', :body => 'stuff'}
    end
    
    def invalid_review
      {:body => ''}
    end

end
