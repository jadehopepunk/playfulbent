class UserLocationsController < ApplicationController
  before_filter :login_required
  before_filter :load_profile_for_editing
  
  def update
    @profile.update_location_with(params[:location])
  end
  
  protected
  
    def load_profile_for_editing
      @profile = Profile.find_by_param(params[:profile_id])
      return access_denied unless @profile.can_be_edited_by?(current_user)
      true
    end
  
  
end
