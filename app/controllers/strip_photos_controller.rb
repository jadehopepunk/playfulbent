class StripPhotosController < ApplicationController
  before_filter :load_strip_photo, :only => [:show, :show_thumb, :next]

  def show
    params[:format] = 'html' unless params[:format] == 'jpg'
    
    respond_to do |format|
      format.html do
        redirect_to("/") && return unless @strip_photo.visible_to?(current_user)
        load_next_photo
        @subject = @strip_photo
        @conversation = Conversation.find_for(@subject)    
      end
      format.jpg do
        @strip_photo.view(current_user)
        x_send_file(@strip_photo.image_for(current_user, :jpg), :type => 'image/jpeg', :disposition => 'inline')
        cache_for 7.days
      end
    end
  end
  
  def show_thumb
    respond_to do |format|
      format.jpg do
        x_send_file(@strip_photo.image_thumb_for(current_user, :jpg), :type => 'image/jpeg', :disposition => 'inline')
        cache_for 7.days
      end
    end
  end
  
  def next
    load_next_photo
  end
  
protected

  def load_next_photo
    @owned_by_viewer = @strip_photo.owned_by(current_user)

    @next_photo = @strip_photo.next_photo

    @next_requires_stripshow = current_user == nil || !current_user.has_stripshow

    unless @next_photo == nil
      @next_is_first_time = @next_photo != nil && !@next_photo.has_been_viewed_by(current_user)
      @next_is_accessable = @next_photo != nil && @next_photo.visible_to?(current_user)
      @next_exposed_photos = StripPhoto.find_for_position(current_user, @next_photo.position + 1)
    end
  end

  def load_strip_photo
    @strip_photo = StripPhoto.find(params[:id])
    return access_denied if @strip_photo.disabled?
  end

  def cache_for(seconds)
    response.headers["Cache-Control"] = "public, max-age=#{seconds}"
    #response.headers["expires"] = seconds.from_now.getgm.strftime("%a, %d %b %Y %H:%M:%S %Z")    
  end  
  
end
