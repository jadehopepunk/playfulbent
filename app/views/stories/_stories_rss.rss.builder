xml.instruct! 
xml.rss "version" => "2.0", 
"xmlns:dc" => "http://purl.org/dc/elements/1.1/" do 
  xml.channel do 
    xml.title 'Playful-Bent Stories' 
    xml.link formatted_stories_url(:rss)
    xml.description "The latest erotic storied written at Playful-Bent."
  	xml.generator("http://www.playfulbent.com/")
  	for story in stories_rss
      xml.item do 
  			xml.title story.title
  			xml.link story_url(story)
  			xml.pubDate CGI.rfc1123_date(story.created_on)
  			xml.generator "http://www.playful-bet.com/"
  			xml.description story.first_page_text
      end 
    end 
  end 
end