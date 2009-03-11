module EmailHandler
  class UserMessageHandler < BaseHandler
    
    def process
      if to_user?
        if from_user?
          @email.verify_sender(sender_user)
          processed
        else
          send_request_to_verify_sender
        end
        handled
      end
    end
    
    def found_recipient?
      to_user? && to_correct_domain?
    end
    
    protected
    
      def to_correct_domain?
        @email.recipient_domain == 'playfulbent.com'
      end
    
      def from_user?
        sender_user
      end
      
      def sender_user
        sender_address_record.user if sender_address_record
      end
    
      def sender_address_record
        @sender_address_record ||= EmailAddress.find_by_address(@email.sender_address)
      end
    
      def to_user?
        @email.recipient
      end
  
      def send_request_to_verify_sender
        CommsMailer.deliver_verify_new_sender(@email, @email.sender_address, @email.sender_name)
      end
    
  end
end