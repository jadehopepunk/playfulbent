class FantasiesController < ApplicationController
  before_filter :login_required, :only => :create
  
  def index
    @fantasies = Fantasy.paginate(:all, :order => 'created_at DESC', :page => params[:page])
  end
  
  def new
    @fantasy = Fantasy.new
  end
  
  def create
    @fantasy = Fantasy.new
    @fantasy.creator = current_user
    @fantasy.attributes = params[:fantasy]
    @fantasy.save
    
    respond_to do |format|
      format.html do
        if @fantasy.new_record?
          render :action => 'new'
        else
          redirect_to fantasies_path
        end
      end
    end
  end
  
  def show
    @fantasy = Fantasy.find(params[:id])
    @your_roles = @fantasy.roles_for_user(current_user)
  end
  
end