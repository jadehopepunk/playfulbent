class MyDaresController < UserBaseController
  
  def index
    if current_user
      @responses_to_user = DareResponse.find_users_responses_to(@user, current_user)
      @participated_in_users_dare = (DareResponse.count_users_responses_to(current_user, @user) > 0)
    end

    if own_profile?
      @dare_challenges = DareChallenge.find(:all, :conditions => ["(user_id = ? OR subject_id = ?) AND rejected_at IS NULL", @user.id, @user.id], :order => "completed_at IS NULL DESC, created_at DESC")
    end
  end

  
end
