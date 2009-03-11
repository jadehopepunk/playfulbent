class MessageInteractionsController < UserBaseController
  
  def index
    if logged_in?  
      @exchange_interaction = InteractionExchangeMessages.find_for_actor_and_subject(current_user, @user)
      @have_exchanged_messages = !!@exchange_interaction
      @can_send_messages = logged_in? && current_user.can_send_message_to?(@user)

      load_messages_with_user if @can_send_messages || @have_exchanged_messages
    end
  end

protected

  def area_name
    'messages'
  end
  
  def load_messages_with_user
    @messages = Message.paginate(:per_page => 12, :page => params[:page], :order => 'created_on DESC', :conditions => {:recipient_id => current_user.id, :sender_id => @user.id})
    @unread_message_count = Message.unread_message_count_for(current_user, @user)
  end
  
end
