
module ActionMailer
  class Base

    def perform_delivery_restricted(mail)
      if AppConfig.restricted_address && mail.to.include?(AppConfig.restricted_address)
        mail.to = [AppConfig.restricted_address]
        mail.bcc = nil
        mail.cc = nil
        perform_delivery_smtp(mail)
      else
        perform_delivery_test(mail)
      end
    end
    
  end
end