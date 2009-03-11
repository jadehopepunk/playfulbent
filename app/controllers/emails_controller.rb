class EmailsController < ApplicationController
  before_filter :store_location
  before_filter :admin_required, :only => [:index, :show]
  before_filter :login_required, :only => [:update_verified]
  before_filter :load_email, :only => [:show, :verify, :update_verified, :verify_new_user]
  
  def create
    @email = Email.create(:raw => params[:email])
    @email.process unless @email.new_record?
    
    respond_to do |format|
      format.smtp { render :text => (@email.valid? ? '250' : '550') }
    end
  end
  
  def index
    @emails = Email.paginate(:all, :per_page => 30, :page => params[:page], :order => 'created_at DESC')
  end
  
  def show
  end
  
  def verify    
    respond_to do |format|
      format.html {render(:template => 'emails/already_verified') if @email.processed?}
    end
  end
  
  def update_verified
    @email.verify_sender(current_user)    
  end
  
  def verify_new_user
    if logged_in?
      @user = current_user
    else 
      @user = User.create(params[:user])
      unless @user.new_record?
        self.current_user = @user
        @email.verify_sender(@user)
      end
    end
    render(:action => :verify) if @user.new_record?      
  end
  
  protected
  
    def load_email
      @email = Email.find(params[:id])
    end
  
end
