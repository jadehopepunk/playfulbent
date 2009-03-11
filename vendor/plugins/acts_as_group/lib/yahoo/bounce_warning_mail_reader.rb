module Yahoo

  class BounceWarningMailReader
    
    def initialize(scraper)
      @scraper = scraper
    end
  
    def parse_email(email)
      if is_valid?(email)
        url = unbounce_url(email)
        raise Exception, "This looks like an unbounce email, but I cannot find the unbounce url:\n#{email.encoded}" if url.blank?
        @scraper.visit_unbounce_url(url)
        return true
      end
      false
    end
    
    protected

      def is_valid?(email)
        expected_subject = 'Please reactivate your Yahoo! Groups email address'
        expected_from = /confirm-unbounce-[0-9\-]*@yahoogroups\.com/
        email.subject.strip == expected_subject && email.from.first =~ expected_from
      end
      
      def unbounce_url(email)
        body = text_body_from_email(email)
        search_expression = /http\:\/\/groups.yahoo.com\/unbounce\?adj=[0-9,]*&p=[0-9]*/
        match_results = search_expression.match(body)
        match_results ? match_results[0] : nil
      end
      
      def text_body_from_email(email)
        raise Exception, "We don't except bounce warnings to be multi-part email. This isn't supported by the mail reader. Email dump:\n#{email.encoded}" if email.multipart?
        email.body
      end
    
      
    
  end
  
end