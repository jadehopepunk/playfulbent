require 'page_fetcher'

class ImageFetcher
  FETCH_TIMEOUT = (ENV['RAILS_ENV'] == 'development' ? 20 : 3)
  PARSE_TIMEOUT = (ENV['RAILS_ENV'] == 'development' ? 20 : 2)
  RANK_WINDOW = 2

  def self.fetch_images(url, max_count = 5)
    if is_image_link(url)
      [url]
    else
      begin
        uri = URI.parse(url)
      rescue URI::InvalidURIError
        return []
      end
    
      doc = PageFetcher.fetch_hpricot_doc_if_page_exists(url, FETCH_TIMEOUT, PARSE_TIMEOUT)
      return [] unless doc
      
      all_images = doc.search('img').reject {|image| too_small(image)}.uniq
      all_images.reject! {|image| !right_format(image['src'])}
      
      ranked_images = all_images.map {|image| [rank(image), image]}
      ranked_images = trim_ranks(ranked_images)
      
      sorted_result = ranked_images.collect(&:last)
      
      image_sources = sorted_result.collect {|image| image['src']}.uniq
      image_sources[0..(max_count - 1)].collect {|image| absolute_path(image, uri)}.reject(&:nil?)
    end
  end
    
  def self.follow_redirects(url)
    begin
      uri = URI.parse(url)
    rescue URI::InvalidURIError
      return url
    end
    
    begin
      response = Net::HTTP.get_response(uri)
    rescue Net::HTTPBadResponse, EOFError, NoMethodError, Errno::ECONNREFUSED, Errno::ENOENT, Errno::ECONNRESET, URI::InvalidURIError, Timeout::Error, SocketError, RuntimeError, Net::ProtocolError
      response = nil
    end  
      
    if response
      if response.code == '302' && !response.header['location'].blank?
        begin
          new_uri = URI.parse(response.header['location'])
        rescue URI::InvalidURIError
          return url
        end

        new_uri.scheme = uri.scheme if new_uri.scheme.blank?
        new_uri.host = uri.host if new_uri.host.blank?
        new_uri.port = uri.port if new_uri.port.blank?
        return new_uri.to_s
      end
    end
    url
  end
  
protected

  def self.trim_ranks(ranked_images)
    return ranked_images if ranked_images.empty?
    
    max_rank = best_rank(ranked_images)
    min_rank = max_rank - RANK_WINDOW
    results = []
    for rank in ((min_rank + 1)..max_rank).to_a.reverse
      results += ranked_images.reject {|rank_and_image| rank_and_image.first != rank}
    end
    results
  end
  
  def self.best_rank(ranked_images)
    ranked_images.map(&:first).max
  end

  def self.too_small(image_tag)
    property_too_small(image_tag, 'width', 75) || property_too_small(image_tag, 'height', 75)
  end
  
  def self.right_format(image_url)
    begin
      URI.split(image_url)[5].downcase =~ /\.(jpg|jpeg|png|tif|tiff|gif)$/
    rescue URI::InvalidURIError
      false
    end
  end
  
  def self.property_too_small(image_tag, property_name, size)
    !image_tag[property_name].blank? && image_tag[property_name].to_i.to_s == image_tag[property_name] && image_tag[property_name].to_i < size
  end

  def self.is_image_link(url)
    begin
      URI.split(url)[5] =~ /(jpg|jpeg|gif|png|tif|tiff)$/
    rescue URI::InvalidURIError
      false
    end
  end

  def self.rank(image)
    result = 0
    result += 1 if contains_product(image)
    result += 1 if contains_cover(image)
    result += 1 if not_navigation(image)
    result += 1 if not_called_transparent_or_spacer(image)
    result -= 1 if is_off_on?(image)
    result
  end

  def self.is_off_on?(image)
    image['src'] =~ /(_off\.|_on\.)/
  end
  
  def self.contains_cover(image)
    image.to_s.downcase =~ /cover/
  end
  
  def self.contains_product(image)
    image.to_s.downcase =~ /product|photo|catalog/
  end
  
  def self.not_navigation(image)
    !(image.to_s.downcase =~ /navigation|logo|checkout|cart|menu|star|topnav/)
  end
  
  def self.not_called_transparent_or_spacer(image)
    !(image.to_s.downcase =~ /transparent|spacer/)
  end
  
  def self.has_alt_text(image)
    !image['alt'].blank?
  end
  
  def self.absolute_path(image_url, server_uri)
    unless image_url.blank?
      image_uri = URI.parse(image_url)
      
      server_url = server_uri.to_s
      return URI.join(server_url, image_url).to_s
      
      if image_uri.host.blank?
        uri = URI.new
        uri.scheme = server_uri.scheme
        uri.host = server_uri.host
        uri.path = server_uri.path
        
        if image_uri.path.starts_with? '/' 
          uri.path = image_uri.path
        else
          uri.path += '/' unless uri.path.ends_with? '/'
          #image_uri.path = image_uri.path.slice(2..(image_uri.path.length - 1)) if image_uri.path.starts_with? './'
          uri.path += image_uri.path
        end
      else
        uri = image_uri
      end
      uri.to_s
    end
  end
  
end