class DareGamesController < ApplicationController
  before_filter :store_location, :only => :new
  before_filter :login_required, :only => :create
  
  def new
    @dare_game = DareGame.new
  end
  
  def create
    @dare_game = DareGame.new(params[:dare_game])
    @dare_game.creator = current_user
    
    if @dare_game.save
      redirect_to dare_game_path(@dare_game)
    else
      render :action => :new
    end
  end
  
  def show
    @dare_game = DareGame.find(params[:id])
  end
  
end