class StoriesController < ApplicationController
  before_filter :login_required, :only => [:new, :create]
  before_filter :store_location, :only => [:index, :show]
  before_filter :load_tag, :only => [:index]
  
  def index
    conditions = QueryConditions.append(conditions, @tag.taggable_conditions('Story')) unless @tag.nil?
    includes = []
    
    unless params[:query].blank?
      search_conditions = QueryConditions.for_search('title', params[:query])
      search_conditions = QueryConditions.append_for_search(search_conditions, 'page_versions.text', params[:query], 'OR')
      conditions = QueryConditions.append(conditions, search_conditions)
      includes << :first_page_version
    end
    
    @stories = Story.paginate :conditions => conditions, :order => 'updated_at DESC', :per_page => 8, :page => params[:page], :include => includes
    @popular_tags = Story.popular_ranked_tags(DEFAULT_TAG_CLOUD_SIZE)
    @page_title = "Read and write collaborative erotic stories | Playful Bent"
    
    respond_to do |format|
      format.html
      format.rss { render :partial => 'stories_rss', :object => @stories }
    end
  end
  
  def new
    @story = Story.new
  end
  
  def create
    unless params[:story].nil?
      tags_list = params[:story][:first_page_tag_list] 
      params[:story].delete :first_page_tag_list
    end
      
    @story = Story.new(params[:story])
    @story.author = current_user
    
    if @story.valid? && @story.save
      @story.page_versions.first.update_attributes({:tag_list => tags_list})
      redirect_to child_pages_url(@story, 0)
    else
      respond_to do |format|
        format.html { render :action => "new" }
      end
    end
  end
  
  def show
    redirect_to child_pages_url(params[:id], 0)
  end
  
end
