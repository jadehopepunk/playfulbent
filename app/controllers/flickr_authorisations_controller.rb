class FlickrAuthorisationsController < ApplicationController
  before_filter :login_required
  
  def create
    session[:flickr_authorisation] = {:return_to => params[:return_to]}

    respond_to do |format|
      format.html { redirect_to flickr_login_link }
    end
  end
  
  def check
    FlickrAccount.create_from_frob(params[:frob], current_user)
    target_url = (session[:flickr_authorisation] && !session[:flickr_authorisation][:return_to].blank? ? session[:flickr_authorisation][:return_to] : current_user.profile_url)
    
    respond_to do |format|
      format.html { redirect_to(target_url) }
    end
  end
  
  protected
  
    def flickr
      @flickr || @flickr = Flickr.new(nil, AppConfig.flickr_api_key, AppConfig.flickr_shared_secret)
    end
    
    def flickr_login_link
      flickr.auth.login_link('read')
    end
  
end
