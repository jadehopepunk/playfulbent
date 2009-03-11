class CommsMailer < ActionMailer::Base

  def passthrough(email, recipient_address)
    subject email.subject
    recipients recipient_address
    from email.sender_address
    body :body => email.text_body
  end
  
  def verify_new_sender(email, address, name)
    subject "Pick a username to contact #{email.recipient.name}"
    recipients address
    from 'noreply@playfulbent.com'
    body :email => email, :name => name, :recipient_name => email.recipient.name
  end
  
end
