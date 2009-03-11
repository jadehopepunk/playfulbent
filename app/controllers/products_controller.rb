class ProductsController < ApplicationController
  before_filter :store_location, :only => :new
  before_filter :login_required, :only => :create
  
  def index
    @products = Product.find(:all, :order => 'created_at DESC')
  end
  
  def show
    @product = Product.find(params[:id])
  end
  
  def new
    @product = Product.new
    @product.active_step = 1
  end

  def create
    if params[:product]
      category = params[:product][:category]
      params[:product].delete(:category)
    end
    
    @product = Product.new_from_category(category, params[:product])    
    @current_step = active_step_for(@product)
    if @current_step >= 2
      @possible_images = @product.possible_images(true)
    end

    @saved = @product.save
    
    respond_to do |format|
      format.html { render :action => 'new' }
      format.js
    end
  end

  protected
  
    def active_step_for(product)
      last_active_step = params[:active_step].to_i || 1
      product.active_step = last_active_step
      [last_active_step + 1, max_valid_active_step(product)].min
    end
    
    def max_valid_active_step(product)
      product.ready_to_fetch_page? ? 2 : 1
    end
  
end
