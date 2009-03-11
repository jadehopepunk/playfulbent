class UserBaseController < ApplicationController
  include ProfileTabs
  before_filter :load_user
  before_filter :load_user_base_tabs
  
protected

  def load_user_base_tabs
    load_profile_tabs(area_name.to_sym)
  end

  def load_user
    @user = User.find(params[:user_id])
    @profile = @user.profile if @user
  end
  
  def current_user_can_edit_user
    return access_denied unless @user.can_be_edited_by?(current_user)
  end
  
  def can_edit?
    @user.can_be_edited_by?(current_user)
  end
  helper_method :can_edit?
  
  def own_profile?
    logged_in? && @user == current_user
  end
  helper_method :own_profile?
  
  def area_name
    parts = self.class.name.underscore.split('_')
    parts[0, parts.length - 1].join('_')
  end

end