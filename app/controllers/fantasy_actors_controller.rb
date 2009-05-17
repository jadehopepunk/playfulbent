class FantasyActorsController < ApplicationController
  before_filter :login_required, :only => :create
  
  def create
    @fantasy_actor = FantasyActor.new(params[:fantasy_actor])
    @fantasy_actor.user = current_user
    @fantasy_actor.save!
    
    respond_to do |format|
      format.html do
        redirect_to fantasy_role_path(@fantasy_actor.role)
      end      
    end
  end
  
end
