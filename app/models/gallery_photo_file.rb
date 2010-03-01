# == Schema Information
#
# Table name: gallery_photo_files
#
#  id                     :integer(4)      not null, primary key
#  size                   :integer(4)
#  content_type           :string(255)
#  filename               :string(255)
#  height                 :integer(4)
#  width                  :integer(4)
#  parent_id              :integer(4)
#  thumbnail              :string(255)
#  local_gallery_photo_id :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

class GalleryPhotoFile < ActiveRecord::Base
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 1.megabyte,
                 :resize_to => '600>x1000>',
                 :thumbnails => {
                   :thumb => [80,80],
                   :main => "510>x1000>",
                 },
                 :path_prefix => File.join('private', 'images', table_name)
  validates_as_attachment
                 
  belongs_to :gallery_photo
  
  def self.new_from_uploaded_data(value)
    result = GalleryPhotoFile.new
    result.uploaded_data = value
    result
  end
  
  def format
    content_type.blank? ? nil : content_type.split('/').last.to_sym
  end
  
  def get_file_for_role(role)
    role.blank? ? self : thumbnails.find(:first, :conditions => {:thumbnail => role.to_s}) || self
  end
  
end
