class ProfileBaseController < ApplicationController
  before_filter :load_profile
  
protected

  def load_profile
    param_id = params[:profile_id] ? params[:profile_id] : request.subdomains.first
    @profile = Profile.find_by_param(param_id)
    @user = @profile.user if @profile
    !@profile.nil?
  end
  
end
