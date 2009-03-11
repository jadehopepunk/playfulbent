def add_records(klass, records)
  # Summary
  times = records.values.flatten
  klass.send :create, { :is_total => true,
                        :visit_count => times.size,
                        :average => times.average,
                        :standard_deviation => times.standard_deviation, 
                        :min => times.min,
                        :max => times.max }
  
  # Detail of each record
  records.sort_by { |k,v| v.size}.reverse_each do |req, times|
    next if req.nil? # Skip resources with no name
    klass.send :create, { :combined_name => req, 
                          :visit_count => times.size,
                          :average => times.average,
                          :standard_deviation => times.standard_deviation, 
                          :min => times.min,
                          :max => times.max }
  end
  
end


namespace :log do

  desc "parse the log file"
  task :analyze => [:environment] do
    require 'production_log/analyzer.rb'
    environment = ENV['RAILS_ENV'] || 'production'
    
    puts "Analyzing File..."
      analyzer = Analyzer.new(RAILS_ROOT + "/log/#{environment}.log")
      analyzer.process
    puts "Done"

    puts "Recording..."
      add_records(LoggedRequestTime, analyzer.request_times)
      add_records(LoggedDbTime, analyzer.db_times)
      add_records(LoggedRenderTime, analyzer.render_times)    
    puts "Done"

  end

end