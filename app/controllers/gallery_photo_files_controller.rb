class GalleryPhotoFilesController < ApplicationController
  before_filter :load_gallery_photo
  # after_filter :cache_photo_if_public, :only => :show
  
  def show
    @gallery_photo_file = @gallery_photo.get_file_for_role(params[:id])
    if @gallery_photo.can_be_viewed_by?(current_user)
      render_gallery_photo
    else
      x_send_file(access_denied_file, :type => 'image/jpg', :status => 200, :disposition => 'inline')
    end
  end
  
  protected
  
    def render_gallery_photo
      x_send_file(@gallery_photo_file.full_filename, :type => @gallery_photo_file.content_type, :status => 200, :disposition => 'inline')
    rescue ActionController::MissingFile
      render :nothing => true, :status => 404
    end
  
    def load_gallery_photo
      @gallery_photo = GalleryPhoto.find(params[:photo_id])
    end
    
    # def cache_photo_if_public
    #   cache_page if @gallery_photo.public?
    # end

    def access_denied_file
      RAILS_ROOT + "/public/images/access_denied_thumb.jpg"
    end
  
end
