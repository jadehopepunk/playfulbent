
module FeedFetcher
  class FeedSourceError < RuntimeError
  end

  class NoFeedForPageError < RuntimeError
  end

  class PageFeedError < RuntimeError
  end

  class PageDoesntExistError < RuntimeError
  end

  class FeedFetcher
  
    def self.get_feed_source(page_url)
      page_url = url_with_protocol(page_url)
    
      doc = get_feed_doc(page_url)
    
      if doc.nil?
        raise PageDoesntExistError
      elsif is_rss_feed? doc
         return grab_feed_details_from_rss(page_url)
      elsif is_html_page? doc
        if html_has_rss_link? doc
          return grab_feed_details_from_rss(rss_link_from_html(doc))
        end
      else
        raise NoFeedForPageError
      end
      nil
    end
  
  protected
  
    def self.grab_feed_details_from_rss(new_feed_url)
      doc = get_feed_doc(new_feed_url)
      if doc
        title_element = doc.search("//rss/channel/title")[0]
        title = doc.search("//rss/channel/title")[0].inner_html if title_element

        result = FeedSource.new(new_feed_url, title)
        return result
      end

      raise PageFeedError
    end
  
    def self.is_rss_feed?(doc)
      !doc.search("//rss").empty?
    end
  
    def self.is_html_page?(doc)
      !doc.search("//html").empty?    
    end
  
    def self.html_has_rss_link?(doc)
      !rss_link_from_html(doc).blank?
    end
  
    def self.rss_link_from_html(doc)
      results = doc.search("//html/head/link[@type='application/rss+xml']")
      return nil if results.empty?
      results[0][:href]
    end
  
    def self.get_feed_doc(site_url_to_open)
      require 'hpricot'
      require 'open-uri'
  
      site = PageFetcher::fetch_page(site_url_to_open)
      return nil unless site
      Hpricot(site)
    end
  
    def self.check_feed_url
      if @feed_error
        errors.add_to_base @feed_error
      end
    end
  
    def self.url_with_protocol(original_url)
      if original_url
        unless original_url =~ /[a-zA-Z]*\:/
          return 'http://' + original_url
        end
        original_url
      end
    end
  end
  
end