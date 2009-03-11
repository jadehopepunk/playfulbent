class MyBlogsController < UserBaseController
  
  def index
    @syndicated_blog = @user.syndicated_blog
    load_paginated_index
  end
  
  def new
    @syndicated_blog = SyndicatedBlog.new
  end
  
  def create
    @syndicated_blog = SyndicatedBlog.new(params[:syndicated_blog])
    @syndicated_blog.user = @user
    return access_denied unless @syndicated_blog.can_be_edited_by? current_user
    
    @syndicated_blog.save
    load_paginated_index
  end
  
  def destroy
    @syndicated_blog = SyndicatedBlog.find(params[:id])
    return access_denied unless @syndicated_blog.can_be_edited_by? current_user
    @syndicated_blog.destroy
  end
  
protected

  def load_paginated_index
    if @syndicated_blog
      @blog_articles = SyndicatedBlogArticle.paginate(:all, :per_page => 10, :page => params[:page], :conditions => ["syndicated_blog_id = ?", @syndicated_blog.id], :order => 'published_at DESC', :include => :tags)
    end
  end
  
end
