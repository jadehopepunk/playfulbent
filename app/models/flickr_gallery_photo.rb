# == Schema Information
# Schema version: 258
#
# Table name: gallery_photos
#
#  id           :integer(11)   not null, primary key
#  created_on   :datetime      
#  title        :string(255)   default(Untitled)
#  position     :integer(11)   
#  photo_set_id :integer(11)   
#  type         :string(255)   
#  flickr_id    :string(255)   
#  server       :string(255)   
#  secret       :string(255)   
#  version      :integer(11)   default(1)
#


class FlickrGalleryPhoto < GalleryPhoto
  
  def self.create_from_flickr_data(flickr_data, photo_set, new_position, new_version)
    result = FlickrGalleryPhoto.new(:photo_set => photo_set)
    result.flickr_data = flickr_data
    result.position = new_position
    result.version = new_version
    result.save
    result
  end
  
  def update_from_flickr_data(value, new_position, new_version)
    self.flickr_data = value
    self.position = new_position
    self.version = new_version
    save
  end
  
  def flickr_data=(value)
    self.title = value.title
    self.flickr_id = value.id
    self.server = value.server
    self.secret = value.secret
    self.tag_list = value.tags.map(&:raw).join(',')
  end

  def image_url(role = :main)
    size = (role == 'thumb' ? '_s' : '')
		base = 'http://static.flickr.com'
		return "#{base}/#{server}/#{flickr_id}_#{secret}#{size}.jpg"
  end
  
  def external_page_url
    "http://www.flickr.com/photos/#{flickr_nsid}/#{flickr_id}"
  end
  
  protected
  
    def flickr_nsid
      photo_set.flickr_nsid if photo_set
    end
  
    def add_to_list_bottom
      self[position_column] = bottom_position_in_list.to_i + 1
    end
  
  
end
