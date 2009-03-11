module Additional
  module PermissionsHelper
    
    def is_review_admin?
      logged_in? && (current_user.is_review_manager? || current_user.is_admin?)
    end
    
  end
end
