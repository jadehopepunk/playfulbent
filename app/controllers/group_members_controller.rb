class GroupMembersController < ApplicationController
  include GroupTabs
  before_filter :load_group
  before_filter :load_group_members_tab
  before_filter :restrict_access_to_members, :except => [:create]
  before_filter :login_required, :only => [:create]
  
  def index
    @external_profiles = @group.yahoo_profiles.paginate(:all, :per_page => 10, :page => params[:page], :order => 'identifier')
    
    respond_to :html
  end
  
  def create
    @group_membership = GroupMembership.fetch_for(@group, params[:group_membership])
    @saved = @group_membership.save
    
    if @saved
      if @group_membership.user.nil?
        @group_membership.yahoo_profile.user = current_user
        @group_membership.yahoo_profile.save!
      elsif @group_membership.user != current_user
        @group_membership.errors.add_to_base "You have the correct password, but this user has already been claimed by someone else"
        @saved = false
      end
    end
    
    respond_to :js
  end
  
  protected 
  
    def load_group
      @group = Group.find_by_param(params[:group_id])
    end
  
    def load_group_members_tab
      load_tabs :members
    end
    
    def no_access_to_members_list
      respond_to do |format|
        format.html do
          render :template => 'group_members/no_access.html.erb'
        end
      end
      return false
    end
    
    def restrict_access_to_members
      return no_access_to_members_list unless @group.members_list_can_be_read_by?(current_user) 
    end
  
end
