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


class LocalGalleryPhoto < GalleryPhoto
  has_one :gallery_photo_file, :dependent => :destroy

  validates_presence_of :gallery_photo_file
  validates_associated :gallery_photo_file, :on => :create
  
  def image_url(role = :main)
    if photo_set
      "/photo_sets/#{photo_set.id}/photos/#{id}/files/#{role}.#{format}"
    else
      "/photos/#{id}/files/#{role}.#{format}"
    end
  end

  def format
    gallery_photo_file ? gallery_photo_file.format : :jpg
  end
  
  def get_file_for_role(role)
    gallery_photo_file.get_file_for_role(role) if gallery_photo_file
  end
  
  def uploaded_data
  end
  
  def uploaded_data=(value)
    if value
  	  self.gallery_photo_file = nil if gallery_photo_file
  	  self.gallery_photo_file = GalleryPhotoFile.new_from_uploaded_data(value)
  	end
  end

end
