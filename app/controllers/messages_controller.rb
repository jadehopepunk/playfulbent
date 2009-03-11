class MessagesController < UserBaseController
  before_filter :login_required
  before_filter :load_user
  before_filter :load_parent_message, :only => [:new, :create]
  before_filter :current_user_can_edit_user
  
  def index
    @messages = Message.paginate(:all, :per_page => 12, :page => params[:page], :order => 'created_on DESC', :conditions => {:recipient_id => @user.id})
    calculate_unread_messages
  end
  
  def sent
    @messages = Message.paginate(:all, :per_page => 12, :page => params[:page], :order => 'created_on DESC', :conditions => {:sender_id => @user.id})
  end
  
  def new
    @message = Message.new(:parent => @parent, :recipient => @recipient, :subject => @subject)
    @message
    
    respond_to do |format|
      format.html
      format.js { render :layout => false, :partial => 'new_redbox' }
    end      
  end
  
  def create
    @message = Message.new(params[:message])
    @message.sender = @user
    return access_denied unless @message.can_be_edited_by? current_user
    
    @saved = @message.save

    respond_to do |format|
      format.html do
        if @saved
          redirect_to user_messages_path(@user)
        else
          render :action => :new
        end
      end
      format.js # create.rjs
    end      
  end
  
  def read
    @message = Message.find(params[:id])
    @message.read(current_user)
    calculate_unread_messages
    
    respond_to :js
  end
  
protected 

  def load_parent_message
    if params[:parent_id]
      @parent = Message.find(params[:parent_id])
      return false unless @parent
      @recipient = @parent.sender
      @subject = @parent.subject
    elsif params[:recipient_id]
      @recipient = User.find(params[:recipient_id])
    end
    true
  end
  
  def calculate_unread_messages
    @unread_message_count = Message.unread_message_count_for(current_user)
  end
  
end
