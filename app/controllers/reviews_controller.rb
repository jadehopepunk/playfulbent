class ReviewsController < ApplicationController
  before_filter :store_location
  before_filter :login_required, :only => [:create, :edit]
  before_filter :load_product, :only => [:new, :create]
  before_filter :load_review, :only => [:show, :edit, :update]
  before_filter :can_edit_review, :only => [:edit, :update]
  before_filter :load_tag, :only => [:index]
  before_filter :load_order, :only => [:index]

  def index
    add_rss 'Playful Bent - All Reviews'
    @possible_orders = [:most_recent, :highest_rated]
    @order = @possible_orders.first if @order.nil?
    @page_title = "Playful Bent - Reviews of sex toys, books and adult sites"
    
    conditions = QueryConditions.append(conditions, @tag.taggable_conditions('Review')) unless @tag.nil?
    conditions = QueryConditions.append(conditions, ["products.type = ?", "Product#{params[:type]}"]) unless params[:type].blank?
    
    respond_to do |format|
      format.html do
        @featured_review = Review.find_featured
        conditions = QueryConditions.append(conditions, ["reviews.id != ?", @featured_review.id]) unless @featured_review.nil?
        @reviews = Review.paginate(:order => review_order_statement(@order), :conditions => conditions, :per_page => 10, :page => params[:page], :include => :product)
        @popular_ranked_tags = Review.popular_ranked_tags(DEFAULT_TAG_CLOUD_SIZE)
      end
      format.rss do 
        @reviews = Review.paginate(:order => review_order_statement(@order), :conditions => conditions, :per_page => 10, :page => params[:page], :include => :product)
        render :template => 'reviews/index.rss.builder', :layout => false 
      end
    end
  end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(params[:review])
    @review.user = current_user
    @review.product = @product
    @success = @review.save
    
    respond_to do |format|
      format.html do
        if @success
          if @review.product.is_a?(ProductSexToy)
            redirect_to new_review_action_shot_path(@review)
          else
            redirect_to review_path(@review)
          end
        else
          render :action => 'new'
        end
      end
    end
  end
  
  def show
    @page_title = "#{@review.user.name} reviews the #{@review.product.name} | Playful Bent"
    @meta_description = @review.body
    @subject = @review
    @conversation = Conversation.find_for(@subject)    
  end
  
  def edit
  end
  
  def update
    @success = @review.update_attributes(params[:review])
    
    respond_to do |format|
      format.html do
        if @success
          redirect_to review_path(@review)
        else
          render :action => 'edit'
        end
      end
    end
  end

  protected

    def load_product
      @product = Product.find(params[:product_id])
    end
    
    def load_review
      @review = Review.find(params[:id])
      @product = @review.product
    end
    
    def can_edit_review
      return access_denied unless @review.user == current_user
    end

    def review_order_statement(order_name)
      if order_name == :highest_rated
        return 'reviews.overall_rating DESC'
      else
        return 'reviews.created_at DESC'
      end
    end

end
