class FantasyRolesController < ApplicationController
  
  def show
    @fantasy_role = FantasyRole.find(params[:id])
    @fantasy = @fantasy_role.fantasy
    @other_actors = @fantasy_role.other_actors(current_user)
  end
  
end
