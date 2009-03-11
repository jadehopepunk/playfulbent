require 'open-uri'
require 'timeout'
require 'hpricot'

class PageFetcher
  
  def self.fetch_hpricot_doc_if_page_exists(url, fetching_timeout = 3, parsing_timeout = 2)
    html_body = PageFetcher.fetch_page_if_exists(url, fetching_timeout)
    doc = nil

    begin
      Timeout::timeout(parsing_timeout) do
        doc = Hpricot.parse(html_body) if html_body
      end
    rescue Hpricot::ParseError, TypeError, Timeout::Error, Errno::EINVAL
    end

    doc
  end
  
  def self.fetch_rexml_doc_if_page_exists(url, fetching_timeout = 2, parsing_timeout = 2)
    xml_body = PageFetcher.fetch_response_if_exists(url, fetching_timeout)
    doc =  nil
    
    begin
      Timeout::timeout(parsing_timeout) do
        doc = REXML::Document.new(xml_body) if xml_body
      end
    rescue Timeout::Error, REXML::ParseException
    end
    
    doc
  end
  
  def self.fetch_response_if_exists(url, timeout_seconds = 3)
    unless url.blank?
      begin
        uri = URI.parse(url)
        Timeout::timeout(timeout_seconds) do
          response = Net::HTTP.get_response(uri)
          return response.body if response
        end
      rescue Timeout::Error, Errno::ECONNREFUSED, Errno::ENOENT, Errno::ECONNRESET, OpenURI::HTTPError, URI::InvalidURIError, SocketError, RuntimeError, Net::ProtocolError, Net::HTTPBadResponse
      rescue
      end
    end
    nil
  end

  def self.fetch_page_if_exists(url, timeout_seconds = 3)
    unless url.blank?
      begin
        Timeout::timeout(timeout_seconds) do
          return PageFetcher.fetch_page(url)
        end
      rescue Errno::ECONNREFUSED, Errno::ENOENT, Errno::ECONNRESET, OpenURI::HTTPError, URI::InvalidURIError, Timeout::Error, SocketError, RuntimeError, Net::ProtocolError, Net::HTTPBadResponse, OpenSSL::SSL::SSLError, NoMethodError, Errno::ETIMEDOUT
      end
    end
    nil
  end
  
  def self.fetch_page(url)
    open(url)
  end
  
  def self.fetch_response(url)
    Net::HTTP.get_response(uri)
  end
  
end