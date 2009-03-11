require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_io')

class IO
  def self.select(io_array, input_buffer, output_buffer, wait_time)
    io_array.first.mock_select
  end
end

describe SmtpServer, "on connection" do
  
  before do
    @io = MockIO.new
    @server = SmtpServer.new('http://test.host/emails', 1234)
  end
  
  it "should output 220" do
    @server.serve(@io)
    @io.buffer.first.should == "220 hello\r\n"
  end
  
end

describe SmtpServer, "on closing" do

  before do
    @io = MockIO.new
    @server = SmtpServer.new('http://test.host/emails', 1234)
  end

  it "shoud output 221" do
    @server.serve(@io)
    @io.buffer.last.should == "221 bye\r\n"
    @io.buffer.length.should == 2
  end
  
end

describe SmtpServer, "after connection" do
  
  before do
    @io = MockIO.new
    @server = SmtpServer.new('http://test.host/emails', 1234)
  end
  
  it "should respond to HELO with 220" do
    @io.input = ['HELO relay.example.org']
    @server.serve(@io)
    @io.buffer[1..-2].should == ["220 and..?\r\n"]
  end
  
  it "should respond to QUIT by disconnecting" do
    @io.input = ['QUIT', 'HELO']
    @server.serve(@io)
    @io.buffer.last.should == "221 bye\r\n"
    @io.buffer.length.should == 2
  end
  
  it "should respond to MAIL FROM with 220" do
    @io.input = ['MAIL FROM:<craig@craigambrose.com>']
    @server.serve(@io)
    @io.buffer[1..-2].should == ["220 OK\r\n"]
  end
  
  it "should respond to RCPT TO with 220" do
    @io.input = ['RCPT TO:<frodo@craigambrose.com>']
    @server.serve(@io)
    @io.buffer[1..-2].should == ["220 OK\r\n"]
  end
  
  it "should respond to DATA with 354" do
    @io.input = ['MAIL FROM:<craig@craigambrose.com>', 'RCPT TO:<frodo@craigambrose.com>', 'DATA']
    @server.serve(@io)
    @io.buffer[3..-2].should == ["354 End data with <CR><LF>.<CR><LF>\r\n"]
  end
    
end

describe SmtpServer, 'when data block received' do

  before do
    @io = MockIO.new
    @io.input = ['DATA', 'some crap', '.']
    @server = SmtpServer.new('http://test.host/emails', 1234)
  end

  it "should respond OK if email can be posted to target url" do
    Net::HTTP.should_receive(:post_form).with(URI.parse('http://test.host/emails'), {'email' => "some crap\r\n"}).and_return(Net::HTTPSuccess.new('1.2', '200', 'OK'))
    @server.serve(@io)
    @io.buffer[-2].should == "220 OK\r\n"
  end
  
  it "should return 450 (not available) if target url doesnt return success" do
    Net::HTTP.should_receive(:post_form).with(URI.parse('http://test.host/emails'), {'email' => "some crap\r\n"}).and_return(Net::HTTPBadRequest.new('1.2', '450', 'stuff'))
    @server.serve(@io)
    @io.buffer[-2].should == "450 Try again later\r\n"
  end

end