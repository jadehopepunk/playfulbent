module EmailHandler
  class AdminHandler < BaseHandler
    ADMIN_USERNAMES = %w(suggestions abuse root postmaster noreply)

    def process
      if to_admin?
        deliver_passthrough
        processed
        handled
      end
    end
    
    def found_recipient?
      to_admin?
    end
    
    protected
    
      def to_admin?
        ADMIN_USERNAMES.include?(@email.recipient_username)
      end

      def deliver_passthrough
        CommsMailer.deliver_passthrough(@email, AppConfig.support_address)
      end
    
  end
end