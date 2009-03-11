require File.dirname(__FILE__) + '/../test_helper'
require 'products_controller'

# Re-raise errors caught by the controller.
class ProductsController; def rescue_action(e) raise e end; end

class ProductsControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :products, :product_images
  
  def setup
    @controller = ProductsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #----------------------------------------------------------
  # NEW
  #----------------------------------------------------------
  
  def test_that_new_displays_template
    get :new
    
    assert_response :success
    assert_select 'div.review_form'
  end
  
  #----------------------------------------------------------
  # CREATE
  #----------------------------------------------------------
  
  def test_that_create_requires_login
    assert_requires_login do |proxy|
      proxy.post :create
    end
  end
  
  def test_that_create_redisplays_template_if_product_not_valid
    login_as :frodo
    post :create, :format => 'js'
    
    assert_response :success
    assert_select_rjs :replace_html, 'new_form_container'
  end
  
  def test_that_create_redirects_to_new_review_page_if_product_valid
    login_as :frodo
    post :create, :format => 'js', :active_step => '2', :product => valid_product_params
    
    assert_response :success
    product = assigns(:product)
    assert product
    assert !product.new_record?
    assert_equal "window.location.href = \"/reviews/new?product_id=#{product.id}\";", @response.body
  end
  
  protected
  
    def valid_product_params
      {:url => 'craigambrose.com', :name => 'Craig Ambrose', :category => 'ProductWebSite'}
    end
  
  
end
