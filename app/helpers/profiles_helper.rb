module ProfilesHelper
  include Additional::RemoteQueueHelper
  include Additional::TabSystemHelper  
  
	def order_by_links(possible_orders)
	  link_array = possible_orders.collect do |order|
	    title = order.to_s.titleize
	    
	    if order == :most_interactions_with_you && !logged_in?
  	    link_to title, about_interactions_home_url, :class => 'inactive_order'	      
	    elsif order == @order
	      content_tag 'span', title, :class => 'active_order'
	    else
  	    link_options = {:order => order}
  	    link_options[:tag] = @tag.name if @tag
  	    link_options[:query] = params[:query] unless params[:query].blank?
  	    link_options[:show_all] = params[:show_all] unless params[:show_all].blank?

  	    link_to title, link_options, :class => 'inactive_order'
	    end
	      
	  end
	  link_array.join(' | ')
	end
  
  
end
