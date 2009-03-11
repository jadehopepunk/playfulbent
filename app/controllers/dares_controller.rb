require 'linguistics'
Linguistics::use( :en ) # extends Array, String, and Numeric

class DaresController < ApplicationController
  before_filter :store_location, :only => [:show]
  before_filter :login_required, :only => [:new, :create]
  before_filter :load_tag, :only => :index
  
  def index
    redirect_to :controller => 'dare_responses'
  end
  
  def new
    @dare = Dare.new    
  end
  
  def create
    @dare = Dare.new(params[:dare])
    @dare.creator = current_user
    if @dare.valid? && @dare.save
      @dare.tag_list = params[:dare][:tag_list]
      @dare.save
      
      redirect_to dares_url()
    else
      render :action => 'new'
    end
  end
  
  def show
    @dare = Dare.find(params[:id])
    @subject = @dare
    @conversation = Conversation.find_for(@dare)
  end
  
end
