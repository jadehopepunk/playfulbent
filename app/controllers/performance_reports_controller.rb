class PerformanceReportsController < ApplicationController
  before_filter :admin_required
  
  def index
    @date = (params[:date] && params[:date].to_date) || Date.today
    @request_times = LoggedRequestTime.find(:all, :order => 'is_total DESC, average DESC', :conditions => {:created_on => @date})
    @max = 0.2    
    @yesterday = @date - 1
    @tomorrow = @date + 1 unless @date >= Date.today
  end
  
end
