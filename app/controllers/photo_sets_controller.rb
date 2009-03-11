class PhotoSetsController < UserBaseController
  skip_before_filter :load_user
  skip_before_filter :load_user_base_tabs

  before_filter :login_required, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :load_user
  before_filter :current_user_can_edit_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :load_photo_set, :only => [:show, :edit, :update, :check_importing, :destroy]
  before_filter :load_user_base_tabs, :except => [:destroy]
  
  def index
    load_photo_sets
    @photo_set = @photo_sets.first
    load_index
    @gallery_photo = @gallery_photos.first
    load_conversation    

    respond_to do |format|
      format.html {render :action => 'show'}
    end
  end
  
  def show
    load_index
    load_photo_sets
    @gallery_photo = @gallery_photos.first
    load_conversation    
  end

  def new
    @photo_set = new_photo_set_class.new
    load_flickr_account
  end
  
  def create
    load_flickr_account
    @photo_set = photo_set_class.new(photo_set_params_without_type)    
    @photo_set.profile = @profile
    success = @photo_set.save
    
    respond_to do |format|
      format.html do
        if success
          redirect_to user_photo_set_path(@user, @photo_set)
        else
          render :action => 'new'
        end
      end
    end
  end
  
  def edit
  end
  
  def update
    @success = @photo_set.update_attributes(params[:photo_set])
    
    if @success && @photo_set.viewable_by != 'everyone'
      FileUtils.rm_rf(File.join(RAILS_ROOT, 'public', 'photo_sets', @photo_set.id.to_s, 'photos'))
    end

    respond_to do |format|
      format.html do
        if @success
          redirect_to user_photo_set_path(@user, @photo_set)
        else
          render :action => 'edit'
        end
      end
    end
  end
  
  def check_importing
  end
  
  def destroy
    @photo_set.destroy
    @default_set = @user.default_photo_set
    
    respond_to do |format|
      format.html do
        if @default_set
          redirect_to user_photo_set_url(@user, @default_set)
        else
          redirect_to @user.profile_url
        end
      end
    end
  end
  
  protected
  
    def load_photo_set
      @photo_set = @profile.photo_sets.find(params[:id])
      return access_denied unless @photo_set.can_be_viewed_by?(current_user)
    end
    
    def load_flickr_account
      @flickr_account = @user.flickr_account
    end

    def load_index
      if @tag
        @gallery_photos = @photo_set.gallery_photos.find(:all, :conditions => @tag.taggable_conditions('GalleryPhoto'))
      else
        @gallery_photos = @photo_set.gallery_photos
      end
    end

    def load_photo_sets
      @photo_sets = @profile.photo_sets_to_preview_for(current_user)
    end

    def load_conversation
      @subject = @gallery_photo
      @conversation = Conversation.find_for(@subject, GalleryPhoto.name)
    end
    
    def photo_set_params
      params['photo_set'] || {}
    end

    def new_photo_set_class
      params['type_name'] == 'FlickrPhotoSet' ? FlickrPhotoSet : PhotoSet
    end
    
    def photo_set_class
      photo_set_params['type_name'] == 'FlickrPhotoSet' ? FlickrPhotoSet : LocalPhotoSet
    end

    def photo_set_params_without_type
      photo_set_params.reject {|key, value| key == 'type_name'}
    end
    
end
