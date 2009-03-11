class DareChallengeResponsesController < ApplicationController
  before_filter :login_required, :only => [:create]
  before_filter :load_dare_challenge
  
  def create
    @dare_challenge_response = DareChallengeResponse.new(params[:dare_challenge_response])
    @dare_challenge_response.dare_challenge = @dare_challenge
    @dare_challenge_response.user = current_user
    saved = @dare_challenge_response.save
    
    respond_to do |format|
      format.html do
        if saved
          redirect_to dare_challenge_path(@dare_challenge)
        else
          render :template => 'dare_challenges/awaiting_your_dare_response'
        end
      end
    end
  end
  
  protected
  
    def load_dare_challenge
      if @dare_challenge = DareChallenge.find(params[:dare_challenge_id])
        return access_denied unless @dare_challenge.is_participating?(current_user)
        @other_party = @dare_challenge.other_party(current_user)
        @your_dare_text = @dare_challenge.dare_for(current_user)
      end
    end
  
end
