class DareGamePlayersController < ApplicationController
  before_filter :load_dare_game
  before_filter :login_required
  
  def create
    @dare_game.users << current_user unless @dare_game.users.include?(current_user)
    redirect_to @dare_game
  end
  
  def destroy
    @dare_game_player = @dare_game.dare_game_players.find_by_user_id(current_user.id)
    @dare_game_player.destroy if @dare_game_player
    redirect_to @dare_game
  end
  
  private
  
    def load_dare_game
      @dare_game = DareGame.find(params[:dare_game_id])
    end
  
end