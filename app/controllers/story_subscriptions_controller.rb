class StorySubscriptionsController < ApplicationController
  before_filter :login_required, :only => [:create, :update]  
  before_filter :load_story
  
  def create
    # hack around observe form bug, use this method for update too
    @story_subscription = @story.subscription_for(current_user)
    if !@story_subscription.new_record?
      permission_denied && return unless @story_subscription.can_be_modified_by(current_user)
      @show_errors = !@story_subscription.update_attributes(params[:story_subscription])

      respond_to do |format|
        format.js    #update.rjs
      end
      return
    end
    # end of hack
    
    @story_subscription = StorySubscription.create({:story => @story, :user => current_user}.merge(params[:story_subscription]))
    
    @show_errors = !@story_subscription.valid?
    
    respond_to do |format|
      format.js    #create.rjs
    end
  end
  
  def update
    @story_subscription = @story.story_subscriptions.find(params[:id])
    permission_denied && return unless @story_subscription.can_be_modified_by(current_user)
    
    @show_errors = !@story_subscription.update_attributes(params[:story_subscription])
    
    respond_to do |format|
      format.js    #update.rjs
    end
  end
  
protected

  def load_story
    @story = Story.find(params[:story_id])
  end
  
end
