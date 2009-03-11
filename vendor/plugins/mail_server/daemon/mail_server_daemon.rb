#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../../../config/environment"

$running = true;
Signal.trap("TERM") do 
  $running = false
end

server = SmtpServer.new('http//www.railsmanager.com/emails', 3500)
server.start

while($running) do
  sleep 1
end

server.shutdown