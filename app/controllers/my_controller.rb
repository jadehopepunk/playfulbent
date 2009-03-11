class MyController < ApplicationController
  
  def relationships
    if logged_in?
      redirect_to user_relationships_path(current_user)
    end
  end
  
  def profile
    if logged_in?
      redirect_to current_user.profile_url
    else
      redirect_to new_session_path
    end
  end
  
  def photos
    if logged_in?
      redirect_to user_photo_sets_path(current_user)
    end
  end
  
end
