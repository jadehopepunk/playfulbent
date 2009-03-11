#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../config/environment"

$running = true;
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
  begin
    unless FlickrPhotoSet.process_next
      sleep 5
    end
  rescue Exception => exception
    ActiveRecord::Base.logger << "Exception thrown: #{exception.message}\n"
    NotificationsMailer.deliver_exception_report('flickr daemon', exception)
    sleep 60
  end
    
end