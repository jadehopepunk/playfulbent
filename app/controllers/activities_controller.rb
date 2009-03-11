class ActivitiesController < ApplicationController
  
  def index
    @activities = ActivityGroupArray.new_from_activities(Activity.find(:all, :order => "created_at DESC", :limit => 30))
  end
  
end
