class YahooProfilesController < ApplicationController
  before_filter :login_required, :only => [:claim]
  INVALID_PASSWORD_ERROR = "That is not a valid password for this profile."

  def show
    @yahoo_profile = YahooProfile.find(params[:id])
    
    respond_to do |format|
      format.html do
        redirect_to @yahoo_profile.profile_url if @yahoo_profile.claimed?
      end
    end
  end
  
  def claim
    @yahoo_profile = YahooProfile.find(params[:id])
    if !params[:password].blank? && !@yahoo_profile.claimed? && scraper.check_login(@yahoo_profile.identifier, params[:password])
      @yahoo_profile.user = current_user
      success = @yahoo_profile.save
    end
    
    respond_to do |format|
      format.html do
        unless success
          flash[:claim_profile_error] = INVALID_PASSWORD_ERROR
          redirect_to yahoo_profile_path(@yahoo_profile)
        end
      end
    end
  end
  
  
  protected
  
    def scraper
      Yahoo::Scraper.new(AppConfig.yahoo_scraper_account)
    end
  
end
