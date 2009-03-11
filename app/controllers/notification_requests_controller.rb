class NotificationRequestsController < ApplicationController
  layout false
  
  def create
    @request = NotificationRequest.new(params[:notification_request])
    
    if NotificationRequest.find(:first, :conditions => ["email_address = ?", params[:notification_request][:email_address]]) || @request.save
      @message = "address recorded"
    else
      @message =  "invalid address"
    end    
    
  end
  
end
