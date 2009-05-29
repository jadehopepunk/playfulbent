FeedFetcher::PageFetcher

module FeedFetcher
  class FeedSource
    attr_reader :url, :title
    
    def initialize(new_url, new_title = '')
      @url = new_url
      @title = new_title
    end
    
    def articles
      ensure_rss_loaded
      @rss.items if @rss
    end
    
    def reload
      @rss = nil
    end
    
  protected
  
    def ensure_rss_loaded
      @rss = get_rss unless @rss
    end
    
    def get_rss
      content = PageFetcher.fetch_page(url)
      if content
        rss = RSS::Parser.parse(content, false)
        return rss
      else
        raise FeedSourceError
      end
    end
  
  end
end
