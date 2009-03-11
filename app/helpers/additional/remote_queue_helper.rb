module Additional
  module RemoteQueueHelper
    
    def call_remote_queue(urls = [], spinner_id = nil)
      javascript_tag remote_queue_js(urls.reverse, spinner_id)
    end
    
  protected
    
    def remote_queue_js(urls, spinner_id)
      this_url = urls.pop
      this_options = remote_url_options(this_url)
      
      return nil unless this_url

      if urls.empty?
        this_options[:complete] = "Element.hide('#{spinner_id}')"
      else
        this_options[:complete] = remote_queue_js(urls, spinner_id) unless urls.empty?
      end
      remote_function(this_options)
    end
    
    def remote_url_options(url)
      if url.is_a? Hash
        result = url
      else
        result = {}
        result[:url] = url
        result[:method] = :get
      end
      result
    end
    
  end
end