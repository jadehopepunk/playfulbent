class MailingListMessagesController < ApplicationController
  include GroupTabs
  before_filter :load_group
  before_filter :load_mailing_list_tab
  before_filter :restrict_access_to_members
  
  def index
    @root_messages = @group.root_list_messages.paginate(:all, :per_page => 10, :page => params[:page])
  end
  
  def show
    @message = @group.mailing_list_messages.find(params[:id])
  end
  
  protected
  
    def load_group
      @group = Group.find_by_param(params[:group_id])
    end
    
    def load_mailing_list_tab
      load_tabs :mailing_list
    end
    
    def no_access_to_mailing_list
      respond_to do |format|
        format.html do
          render :template => 'mailing_list_messages/no_access.html.erb'
        end
      end
      return false
    end
    
    def restrict_access_to_members
      return no_access_to_mailing_list unless @group.mailing_list_can_be_read_by?(current_user) 
    end
  
end
