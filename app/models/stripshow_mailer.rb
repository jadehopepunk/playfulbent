class StripshowMailer < ActionMailer::Base
  helper :application

  def viewed(recipient, viewer, photos)
    raise ArgumentError.new("no photos supplied for email notification") if photos.nil? || photos.empty?
    
    subject "Someone Viewed Your Photo"
    recipients recipient.email
    from "noreply@playfulbent.com"
    content_type "multipart/alternative" 
    
    body(:recipient => recipient, :viewer => viewer, :photos => photos)
  end
  
  def invite(invitation)
    subject "Somone has invited you to look at their photos"
    recipients invitation.email_address
    from "noreply@playfulbent.com"

    body(:invitation => invitation)
  end
  
  def invite_user(strip_show, invitation)
    subject "Somone has invited you to look at their photos"
    recipients invitation.recipient.email
    from "noreply@playfulbent.com"
    content_type "multipart/alternative" 

    body :strip_show => strip_show, :invitation => invitation    
  end
  

end