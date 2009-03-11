module EmailHandler
  class SpamHandler < BaseHandler
    
    def process
      if is_spam?
        processed
        handled
      end
    end
    
    def found_recipient?
      false
    end
    
    protected
    
      def is_spam?
        spam_status_header && spam_status_header.starts_with?('Yes')
      end
      
      def spam_status_header
        @email.header_string('X-Spam-Status')
      end
    
  end
end