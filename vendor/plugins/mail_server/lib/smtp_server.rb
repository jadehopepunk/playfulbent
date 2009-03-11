require 'gserver'

class SmtpServer < GServer
  attr_accessor :target_uri, :current_email
  
  def initialize(target_url, port, *args)
    self.target_uri = URI.parse(target_url)
    super(port, *args)
  end
  
  def serve(io)
    @data_mode = false
    puts "Connected"
    io.print "220 hello\r\n"
    loop do
      if IO.select([io], nil, nil, 0.1)
	      data = io.readpartial(4096)
	      puts ">>" + data
	      ok, op = process_line(data)
	      break unless ok
	      io.print op
      end
      break if io.closed?
    end
    io.print "221 bye\r\n"
    io.close
  end
  
  protected

    def process_line(line)
      if (line =~ /^(HELO|EHLO)/)
        return true, "220 and..?\r\n"
      end
      if (line =~ /^QUIT/)
        return false, "bye\r\n"
      end
      if (line =~ /^MAIL FROM\:/)
        return true, "220 OK\r\n"
      end
      if (line =~ /^RCPT TO\:/)
        return true, "220 OK\r\n"
      end
      if (line =~ /^DATA/)
        start_current_email
        return true, "354 End data with <CR><LF>.<CR><LF>\r\n"
      end
      if processing_email? && (line.chomp =~ /^.$/)
        if post_current_email
          end_current_email
          return true, "220 OK\r\n"
        else
          end_current_email
          return true, "450 Try again later\r\n"
        end
      end
      if processing_email?
        current_email << line
        return true, ""
      else
        return true, "500 ERROR\r\n"
      end
    end
    
    def start_current_email
      self.current_email = []
    end
    
    def end_current_email
      self.current_email = nil
    end
    
    def processing_email?
      current_email
    end
    
    def current_email_text
      current_email.join("\r\n")
    end
    
    def post_current_email
      Net::HTTP.post_form(target_uri, {'email' => current_email_text}).is_a?(Net::HTTPSuccess)
    end
  
end