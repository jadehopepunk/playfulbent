# == Schema Information
#
# Table name: avatars
#
#  id         :integer(4)      not null, primary key
#  image      :string(255)
#  profile_id :integer(4)
#

class Avatar < ActiveRecord::Base
  include FileColumnHelper
  
  file_column :image, :magick => 
    {
      :size => "200x200!", 
      :crop => "1:1", 
      :versions => { 
        :thumb => {
          :size => "80x80!", 
          :crop => "1:1"
        }, 
        :polaroid => {
          :transformation => Proc.new do |img| 
            img = crop_resize_then_rotate("1:1", "206x206!", 10, img)
          end
        }
      }
    }, 
    :store_dir => RAILS_ROOT + "/public/system/user/avatar/image", 
    :base_url => "system/user/avatar/image/"
      
  belongs_to :profile
  validates_presence_of :profile, :image
  validates_uniqueness_of :profile_id
  after_create :inform_profile
  
  def self.blank_image_url
    "http://#{ActionController::UrlWriter.default_url_options[:host]}/images/no-person-photo.jpg"
  end
  
  def self.blank_polaroid_image_url
    'no-person-polaroid.jpg'
  end
  
  def image_url
    return image_options[:base_url] + image_relative_path
  end
  
  def thumb_image_url
    return image_options[:base_url] + image_relative_path('thumb')
  end  
  
  def polaroid_image_url
    return image_options[:base_url] + image_relative_path('polaroid')
  end  
  
  def can_be_edited_by?(user)
    profile && profile.can_be_edited_by?(user)
  end

protected

  def self.crop_resize_then_rotate(crop_ratio, size, degrees, img)
    dx, dy = crop_ratio.split(':').map { |x| x.to_f }
    w, h = (img.rows * dx / dy), (img.columns * dy / dx)
    img = img.crop(::Magick::CenterGravity, [img.columns, w].min, [img.rows, h].min, true)

    img = img.change_geometry(size) do |c, r, i|
      i.resize(c, r)
    end
            
    img.rotate(degrees) 
  end
  
  def inform_profile
    profile.ensure_published
  end
  
end
