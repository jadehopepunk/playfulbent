#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../config/environment"

$running = true;
Signal.trap("TERM") do 
  $running = false
end

fetcher = MailFetcher.new

while($running) do
  
  ActiveRecord::Base.logger << "Fetching email at #{Time.now}.\n"
  fetcher.fetch
  ActiveRecord::Base.logger << "\nDone.\n"
  
  sleep 30
end