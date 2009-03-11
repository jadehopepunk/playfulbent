xml.instruct! 
xml.rss "version" => "2.0" do 
  xml.channel do 
    xml.title @rss_title
    xml.link reviews_url
    xml.description h("Reviews of adult products, books and websites, written by Playful Bent members.") 
  	xml.generator("http://www.playfulbent.com/")
  	for review in @reviews
      xml.item do 
  			xml.title h(review.title)
  			xml.link review_url(review)
  			xml.pubDate CGI.rfc1123_date(review.created_at) 
  			xml.generator "http://www.playfulbent.com/"
  			xml.description <<HTML
<div class="review_preview record_preview important_section">
	#{ link_to image_tag(h(review.product.thumbnail_url), :alt => h(review.product.name), :size => '80x80', :class => 'product_image'), review_url(review) }
  <div>
	  #{ stars(review.overall_rating) }
	</div>
	<div class="review_body">#{ truncate(review.body, 200) + link_to('read more', review_url(review)) }</div>
</div>
HTML
      end 
    end 
  end 
end 
