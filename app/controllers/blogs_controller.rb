class BlogsController < ApplicationController
  before_filter :store_location, :only => :index
  before_filter :load_user, :only => :index
  before_filter :load_filters, :only => :index
  before_filter :load_tag, :only => :index
  
  def index    
    blog_title = 'Playful Bent Blogs'
    add_rss blog_title

    respond_to do |format|
      format.html do
        @blog_articles = SyndicatedBlogArticle.paginate({:per_page => 10, :page => params[:page]}.merge(index_find_params))
        @popular_tags = SyndicatedBlogArticle.popular_ranked_tags(DEFAULT_TAG_CLOUD_SIZE)    
      end
      format.rss do
        @blog_articles = SyndicatedBlogArticle.find(:all, index_find_params)
        render :xml => SyndicatedBlogArticle.collection_to_rss(blog_title, @blog_articles, base_url)
      end
    end
  end
  
protected

  def load_user
    if logged_in?
      @user = current_user
    elsif params[:user_id]
      @user = User.find(params[:user_id])
    end
    true
  end

  def index_find_params
    conditions = []
    joins = []
    includes = [:tags]
    group = nil
  
    conditions << @tag.taggable_conditions('SyndicatedBlogArticle') if @tag
    
    if @user
      if @filters.include? :interact
        joins << {:syndicated_blog => {:user => :interactions}}
        conditions << "interactions.actor_id = #{@user.id}"
        group = 'syndicated_blog_articles.id'
      end
    
      if @filters.include? :interest
        my_tags = @user.all_tags.map(&:id).join(',')
        conditions << "(taggings.taggable_type = 'SyndicatedBlogArticle' AND FIND_IN_SET(taggings.tag_id, '#{my_tags}'))"
        group = 'syndicated_blog_articles.id'
      end
    end
    
    conditions = conditions.empty? ? nil : conditions.join(' AND ')
    
    {:order => 'published_at DESC', :conditions => conditions, :joins => joins, :group => group, :include => includes}
  end
  
end
