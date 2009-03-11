class ActionShotsController < ApplicationController
  before_filter :login_required, :only => [:create, :destroy]
  before_filter :load_review
  before_filter :can_edit_review, :only => [:create, :destroy]
  
  def new
    @action_shot = ActionShot.new
  end
  
  def create
    @action_shot = ActionShot.new(params[:action_shot])
    @action_shot.review = @review
    @success = @action_shot.save
    
    respond_to do |format|
      format.html do
        if @success
          redirect_to review_path(@review)
        else
          render :action => 'new'
        end
      end
    end
  end
  
  def destroy
    if params[:id] == '*'
      @action_shots = @review.action_shots
    else
      @action_shot = Review.find(params[:id])
      @action_shots = [@action_shot]
    end
    
    @action_shots.each(&:destroy)
    
    respond_to do |format|
      format.html {redirect_to review_path(@review)}
    end
  end
  
  protected
  
    def load_review
      @review = Review.find(params[:review_id])
    end
    
    def can_edit_review
      return access_denied unless @review.user == current_user
    end
  
end
