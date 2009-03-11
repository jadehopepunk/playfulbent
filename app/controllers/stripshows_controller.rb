class StripshowsController < ApplicationController
  before_filter :login_required, :except => [:about_upload, :index, :rss, :manage]
  before_filter :load_stripshow, :only => [:next_unviewed, :delete]

  def index
    current_user = current_user
    @strip_shows = StripShow.paginate(:conditions => "strip_shows.finished = 1 AND profiles.disabled = 0", :order => 'strip_shows.published_at DESC, strip_shows.id DESC', :include => [{:user => :profile}, :first_photo], :per_page => 10, :page => params[:page])
  end
  
  def about_upload
  end

  def upload
    @strip_show = strip_show
    
    if request.post?
      @next_photo = StripPhoto.new(params[:next_photo])
      @next_photo.strip_show = strip_show
      if @next_photo.valid?
        @next_photo.save
      end
    end

    @photos_ready = strip_show.has_all_photos?
  end
  
  def set_title
    strip_show.title = params[:upload][:title]
    strip_show.save
    @error = "You must give your strip-show a title." if strip_show.title.blank?
  end

  def delete_photo
    @id = params[:id]
    photo = StripPhoto.find(params[:id].to_i)
    photo.destroy
    @new_count = strip_show.strip_photos.length
  end

  def publish
    @strip_show = StripShow.find_for_user(params[:id].to_s, current_user)
    @strip_show.publish
    @strip_show.save
    redirect_to(:controller => "home")
  end

  def view_photo
    redirect_to strip_photo_path(StripPhoto.find(params[:id]))
  end

  def next_unviewed
    redirect_to("/") && return if @strip_show == nil

    @photo = @strip_show.photo_before_next_unviewed(current_user) || @strip_show.first_photo
    redirect_to("/") && return if @photo == nil

    redirect_to(:controller => "stripshows", :action => "view_photo", :id => @photo)
  end
  
  def delete
    @strip_show.destroy if @strip_show.owned_by(current_user)
    redirect_to(:controller => "user")
  end
  
  def rss
    params[:format] = 'rss'
    #@headers["Content-Type"] = "application/rss+xml" 
    @strip_shows = StripShow.find_all_published
    render :action => "rss", :layout => false
  end
  
private

  def load_stripshow
    @strip_show = StripShow.find(params[:id])
  end

  def strip_show
    @strip_show = current_user.unfinished_stripshow if @strip_show == nil
    if @strip_show == nil then
      @strip_show = StripShow.new
      @strip_show.user = current_user
      @strip_show.save
    end
    @strip_show
  end


end
