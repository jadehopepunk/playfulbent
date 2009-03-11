class MyPhotosController < UserBaseController
  before_filter :store_location, :only => [:index, :show]
  before_filter :login_required, :except => [:index, :show]
  before_filter :load_photo_set
  before_filter :load_tag
  
  def index
    load_index
    @gallery_photo = @gallery_photos.first
    load_photo_sets
    load_conversation
    
    respond_to do |format|
      format.html
    end
  end

  def show
    load_gallery_photo
    load_index
    load_photo_sets
    load_conversation
    
    @page_title = @gallery_photo.page_title
    @meta_description = @gallery_photo.meta_description
    @meta_keywords = @gallery_photo.tag_list
    
    respond_to do |format|
      format.html
    end
  end

  def new
    return access_denied unless @user.can_be_edited_by?(current_user)
    
    respond_to do |format|
      format.html
      format.js { render :layout => false, :template => 'my_photos/new.html.erb' }
    end
  end
  
  def create
    @gallery_photo = LocalGalleryPhoto.new(params[:gallery_photo])
    @gallery_photo.photo_set = @photo_set
    permission_denied and return unless @gallery_photo.can_be_edited_by?(current_user)
    
    @success = @gallery_photo.save
    
    respond_to do |format|
      format.html do
        if @success
          redirect_to user_photo_set_my_photo_path(@user, @photo_set, @gallery_photo)
        else
          render :action => 'new'
        end
      end
      format.js do
        load_index if @success
        responds_to_parent {render}
      end
    end
  end
  
  def update_meta
    load_gallery_photo
    access_denied and return unless @gallery_photo.can_be_edited_by?(current_user)
    @gallery_photo.update_attributes params[:gallery_photo]
  end
    
  def destroy
    load_gallery_photo
    access_denied and return unless @gallery_photo.can_be_edited_by?(current_user)
    @gallery_photo.destroy
  end
  
  def reorder
    params[:reorderable_photo_thumbnails].each_with_index do |id, index| 
      gallery_photo = GalleryPhoto.find(id)
      gallery_photo.position = index.to_i
      return access_denied unless gallery_photo.can_be_edited_by?(current_user)
      
      gallery_photo.save!
    end
    @gallery_photos = @photo_set.gallery_photos
  end
  
protected

  def area_name
    'photo_sets'
  end

  def load_index
    if @tag
      @gallery_photos = @photo_set.gallery_photos.find(:all, :conditions => @tag.taggable_conditions('GalleryPhoto'))
    else
      @gallery_photos = @photo_set.gallery_photos
    end
  end
  
  def load_conversation
    @subject = @gallery_photo
    @conversation = Conversation.find_for(@subject, GalleryPhoto.name)
  end
  
  def load_photo_sets
    @photo_sets = @profile.photo_sets_to_preview_for(current_user)
  end
  
  def load_photo_set
    @photo_set = PhotoSet.find(params[:photo_set_id])
    return access_denied unless @photo_set.can_be_viewed_by?(current_user)
  end
  
  def load_gallery_photo
    @gallery_photo = @photo_set.gallery_photos.find(params[:id])
  end
    
end
