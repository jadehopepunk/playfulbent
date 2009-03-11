class FantasyRolesController < ApplicationController
  
  def show
    @fantasy_role = FantasyRole.find(params[:id])
  end
  
end
