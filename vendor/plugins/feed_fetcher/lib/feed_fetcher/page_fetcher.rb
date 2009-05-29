module FeedFetcher
  class PageFetcher
    def self.fetch_page(site_url_to_open)
      begin
        open(site_url_to_open)
      rescue Exception, Errno::ECONNREFUSED, Errno::ENOENT, Errno::ECONNRESET, OpenURI::HTTPError, URI::InvalidURIError, Timeout::Error, SocketError, RuntimeError, Net::ProtocolError, Net::HTTPBadResponse, OpenSSL::SSL::SSLError, NoMethodError, Errno::ETIMEDOUT
        nil
      end
    end
  end
end
