class GroupsController < ApplicationController
  include GroupTabs
  before_filter :login_required, :only => [:new, :create]
  before_filter :admin_required, :only => [:new, :create]
  
  def index
    @groups = Group.paginate(:all, :order => 'created_at DESC', :per_page => 10, :page => params[:page])
  end
  
  def show
    @group = Group.find_by_param(params[:id])
    load_tabs :summary
  end
  
  def new
  end
  
  def create
    @group = Group.new(params[:group])
    @group.owner = current_user
    @group.save
    
    respond_to do |format|
      format.html do
        if @group.new_record?
          render :action => 'new'          
        else
          redirect_to group_path(:id => @group)
        end
      end
    end
  end
    
end
