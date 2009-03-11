xml.instruct! 
xml.rss "version" => "2.0" do 
  xml.channel do 
    xml.title 'Playful-Bent Strip-Shows' 
    xml.link url_for(:only_path => false, :controller => 'stripshows', :action => "rss") 
    xml.description h("The latest strip-show photo sets uploaded at Playful-Bent.") 
  	xml.generator("http://www.playfulbent.com/")
  	for strip_show in @strip_shows
      xml.item do 
  			xml.title(strip_show.title)
  			xml.link(strip_photo_url(strip_show.first_photo))
  			xml.pubDate CGI.rfc1123_date(strip_show.published_at) 
  			xml.generator("http://www.playfulbent.com/")
  			xml.description(link_to(image_tag(strip_show.strip_photos.first.image_thumb_url, :alt => h(strip_show.title)), strip_photo_url(strip_show.first_photo)))
      end 
    end 
  end 
end 
