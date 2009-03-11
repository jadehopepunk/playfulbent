class DareRejectionsController < ApplicationController
  before_filter :login_required
  
  def new
    populate_new_dare_rejection
  end
  
  def create
    populate_new_dare_rejection
    saved = @dare_rejection.update_attributes(params[:dare_rejection])
    
    respond_to do |format|
      format.html do
        if saved
          redirect_to @cancel_url
        else
          render :action => :new
        end
      end
    end
  end
  
  protected
  
    def populate_new_dare_rejection
      @dare_rejection = DareRejection.new
      @dare_rejection.user = current_user
      @dare_rejection.dare_challenge = DareChallenge.find(params[:dare_challenge_id])

      @cancel_url = dare_challenge_path(@dare_rejection.dare_challenge)
    end
  
end
