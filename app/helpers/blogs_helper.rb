module BlogsHelper
  
  def filter_links
    if logged_in?
      possible_filters = [[:interact, 'People I Know'], [:interest, 'My Interests &amp; Kinks']]
      all_filters = possible_filters.map {|filter_array| filter_array[0]}
    
      results = []
      for filter_array in possible_filters
        filter_sym = filter_array[0]
        filter_title = filter_array[1]
        other_filters = @filters.reject {|f| f == filter_sym }
      
        if @filters.include? filter_sym
          filter_param = other_filters.join(':')
          filter_class = 'active_filter'
        else
          filter_param = (other_filters + [filter_sym]).join(':')
          filter_class = nil
        end
        filter_param = nil if filter_param.blank?
        results << link_to(filter_title, blogs_url(:filter => filter_param, :user_id => current_user), :class => filter_class)
      end
      results.join ' | '
    end
  end
  
end
