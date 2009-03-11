class AvatarsController < ProfileBaseController
  before_filter :login_required
  before_filter :user_can_edit_profile
  
  def new
  end

  def create
    @profile.avatar_image = params[:avatar][:image] if params[:avatar]
    
    respond_to do |format|
      format.html { redirect_to @profile.url }
    end
  end
  
  protected
  
    def user_can_edit_profile
      return access_denied unless @profile.can_be_edited_by?(current_user)
      true
    end
    
end
