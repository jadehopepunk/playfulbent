module Additional
  module UrlHelper
    
    def url_for_gallery_photo(gallery_photo, role = nil)
      gallery_photo.image_url(role)
    end
 
  end
end