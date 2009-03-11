require 'net/pop'

class MailFetcher
  
  def fetch
    Net::POP3.start(AppConfig.mailing_list_collector_pop_host, nil, AppConfig.mailing_list_collector_address, AppConfig.mailing_list_collector_password) do |pop|
      for email in pop.mails
        begin
          email_text = email.pop
          if GroupsMailer.receive(email_text) === false
            notify_admin_of_unparsed_email(email_text)
          end
          email.delete
        rescue Exception => exception
          notify_admin_of_exception(exception, email_text)
        end
      end
    end
  end
  
  protected
  
    def notify_admin_of_unparsed_email(email_text)
      message = "An email was collected that was not understood by any of the parsers.\n\n"
      message += "A full dump of the email is as follows:\n"
      message += "----------------------\n"
      message += email_text
      message += "----------------------\n"
      
      NotificationsMailer.deliver_admin_warning(message, nil)
    end
  
    def notify_admin_of_exception(exception, email_text)
      backtrace = exception.backtrace.join("\n")
      message = "Exception raised in mail fetcher (\"#{exception.message}\"), backtrace:\n\n#{backtrace}, Full email dump:\n\n#{email_text}"
      NotificationsMailer.deliver_admin_warning(message, exception)
    end
  
end