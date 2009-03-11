class SettingsController < UserBaseController
  before_filter :login_required
  before_filter :current_user_can_edit_user

  in_place_edit_for :user, :email
  
  def index
  end
  
end
