
module TMail
  class HeaderField
    def raw_body
      @body
    end
  end
end

module Yahoo

  class MailReader
  
    def parse_email(email)
      if is_list_message?(email)
        return nil if MailingListMessage.identifier_already_exists?(message_id_from_email(email))
        message = new_message_from_email(email)
        message.save!
        return message
      end
      false    
    end
  
    def update_message_from_email(mailing_list_message, email)
      sender_address = email.sender_addr.to_s
    
      mailing_list_message.raw_email = email.encoded
      mailing_list_message.sender_address = email.from.first
      mailing_list_message.message_identifier = message_id_from_email(email)
      mailing_list_message.text_body = text_body_from_email(email).strip
      mailing_list_message.group = group_from_email(sender_address)
      mailing_list_message.subject = remove_group_label(email.subject, group_name_from_email(sender_address))
      mailing_list_message.sender_external_profile = YahooProfile.find_or_initialize_by_identifier(email['X-Yahoo-Profile'].body) if email['X-Yahoo-Profile'] && !email['X-Yahoo-Profile'].body.blank?
      mailing_list_message.parent_message_identifier = email['In-Reply-To'].body if email['In-Reply-To']
      mailing_list_message.received_at = email.date
    end  
  
    protected
    
      def new_message_from_email(email)
        result = MailingListMessage.new
        update_message_from_email(result, email)
        result
      end  
  
      def is_list_message?(email)
        email.to && !group_name_from_email(email.to.first).blank?
      end
    
      def text_body_from_email(email)
        return email.body unless email.multipart?
        return text_body_from_parts(email)
      end
    
      def text_body_from_parts(email_part)
        return email_part.body if email_part.content_type == 'text/plain'
      
        for part in email_part.parts
          result = text_body_from_parts(part)
          return result if result
        end
      
        nil
      end
  
      def message_id_from_email(email)
        if email.message_id
          result = email.message_id
        elsif email['Message-ID']
          result = email['Message-ID'].raw_body.strip
        end
        
        raise ArgumentError, "Following message-id is too long (#{result.length} chars): #{result}" if result && result.length > 255
        result
      end
  
      def group_from_email(email_address)
        group_name = group_name_from_email(email_address)
        group_name ? Group.find_by_group_name(group_name) : nil
      end
  
      def group_name_from_email(email_address)
        match = /([a-zA-Z\-_0-9]*)@yahoogroups\.com/.match(email_address)
        match ? match.captures.first : nil
      end 
  
      def remove_group_label(raw_subject, group_name)
        result = raw_subject
        for label in subject_group_labels(group_name)
          result = result.starts_with?(label) ? result[label.length..-1] : result
        end
        result
      end
    
      def subject_group_labels(group_name)
        ["[#{group_name}] ", "(#{group_name}) "]
      end
  end
  
end