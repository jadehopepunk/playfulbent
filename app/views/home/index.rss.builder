xml.instruct! 
xml.rss "version" => "2.0" do 
  xml.channel do 
    xml.title "PB Activity"
    xml.link reviews_url
    xml.description "All activity on Playful Bent."
  	xml.generator("http://www.playfulbent.com/")
  	for activity in @activities
      xml.item do
  			xml.title activity.title
  			xml.link 'stuff'
  			xml.pubDate CGI.rfc1123_date(activity.created_at) 
  			xml.generator "http://www.playfulbent.com/"
  			xml.description render(:partial => "activities/global_#{activity.activity_class.name.underscore}.html.erb", :locals => {:activity => activity})
      end 
    end 
  end 
end 
