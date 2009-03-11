module ReviewsHelper

	def order_by_links(possible_orders)
	  link_array = possible_orders.collect do |order|
	    title = order.to_s.titleize
	    
	    if order == @order
	      content_tag 'span', title, :class => 'active_order'
	    else
  	    link_options = {:order => order}
  	    link_options[:tag] = @tag.name if @tag
  	    link_options[:query] = params[:query] unless params[:query].blank?

  	    link_to title, link_options, :class => 'inactive_order'
	    end
	      
	  end
	  link_array.join(' | ')
	end

end
