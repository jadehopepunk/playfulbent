
class PagesController < ApplicationController
  before_filter :store_location, :only => [:index, :show]
  before_filter :login_required, :only => [:new, :create, :stop_following, :edit, :update]
  before_filter :load_story, :except => [:edit, :update]
  before_filter :load_parent, :except => [:edit, :update]
  
  def index
    @page = (@parent.nil? ? @story.first_page : @parent.page)
    authors = @page.authors
    followers = @page.followers
    followers -= authors
    
    @picture_authors, @other_authors = User.seperate_users_by_picture(authors, 8)
    @picture_readers, @other_readers = User.seperate_users_by_picture(followers, 8)
    
    @page.on_viewed(current_user) if logged_in?
    @story_subscription = @story.subscription_for(current_user)
    
    @subject = @page.first_added_version
    @conversation = Conversation.find_for(@subject)
    @leaf_pages = @story.get_read_leaf_pages_except(current_user, @page)
    
    @page_title = "#{@story.title} | an erotic story on Playful Bent"
    
  end
  
  def stop_following
    @page_version = @story.page_versions.find(params[:id])
    @page_version.stop_following(current_user)
    
    respond_to do |format|
      format.js    #stop_following.rjs
    end
  end
  
  def new
    @page_version = PageVersion.new
  end
  
  def create
    @page_version = PageVersion.new(params[:page_version])
    @page_version.story = @story
    @page_version.author = current_user
    @page_version.parent = @parent
    
    if @page_version.valid? && @page_version.save
      redirect_to child_pages_url(@story, zero_or_id(@parent))
      return
    end

    respond_to do |format|
      format.html { render :action => "new" }
    end
  end
  
  def edit
    @page_version = PageVersion.find(params[:id])
    @story = @page_version.story
    @parent = @page_version.parent
  end
  
  def update
    @page_version = PageVersion.find(params[:id])
    @story = @page_version.story
    @parent = @page_version.parent

    return access_denied unless @page_version.can_be_edited_by?(current_user)
    
    @page_version.update_attributes(params[:page_version])

    respond_to do |format|
      format.html do
        if @page_version.valid?
          redirect_to(child_pages_url(@story, zero_or_id(@parent)))
        else
          render(:action => "edit")
        end
      end
    end

  end
  
protected

  def load_story
    @story = Story.find(params[:story_id])
  end
  
  def load_parent
    @parent = @story.page_versions.find(params[:parent_id]) unless params[:parent_id] == '0'
    true
  end
  
end
