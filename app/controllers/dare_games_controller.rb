class DareGamesController < ApplicationController
  before_filter :store_location, :only => :new
  before_filter :login_required, :only => :create
  before_filter :load_dare_game, :only => [:show, :start]
  
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
    respond_to do |format|
      format.html { render :template => show_template_name }
    end
  end
  
  def index
    @dare_games = DareGame.all
  end
  
  def start
    @dare_game.start!
    redirect_to @dare_game
  end
  
  private
  
    def show_template_name
      "dare_games/show_#{@dare_game.state}"
    end
    
    def load_dare_game
      @dare_game = DareGame.find(params[:id])
    end
  
end