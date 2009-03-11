class ProductUrlsController < ApplicationController
  before_filter :review_admin_required
  before_filter :load_product
  before_filter :load_product_url, :only => [:edit, :update, :destroy]
  
  def index
    @product_urls = @product.product_urls
  end
  
  def edit
  end
  
  def update
    if @product_url.update_attributes(params[:product_url])
      redirect_to_index
    else
      render :action => 'edit'
    end    
  end
  
  def new
    @produt_url = ProductUrl.new
  end
  
  def create
    @product_url = ProductUrl.new(params[:product_url])
    @product_url.product = @product
    
    if @product_url.save
      redirect_to_index
    else
      render :action => 'new'
    end    
  end
  
  def destroy
    @product_url.destroy
    redirect_to_index
  end
  
  protected
  
    def load_product_url
      @product_url = ProductUrl.find(params[:id])
    end
  
    def load_product
      @product = Product.find(params[:product_id])
    end
    
    def redirect_to_index
      redirect_to product_urls_path(@product)      
    end
  
end
