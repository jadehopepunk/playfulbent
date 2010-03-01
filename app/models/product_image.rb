# == Schema Information
#
# Table name: product_images
#
#  id                 :integer(4)      not null, primary key
#  original_image_url :string(255)
#  parent_id          :integer(4)
#  content_type       :string(255)
#  filename           :string(255)
#  thumbnail          :string(255)
#  size               :integer(4)
#  width              :integer(4)
#  height             :integer(4)
#  product_id         :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

class ProductImage < ActiveRecord::Base
  VALID_URL = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z0-9]{2,5}(([0-9]{1,5})?\/.*)?$/ix

  belongs_to :product
  
  has_attachment :content_type => :image, 
                 :storage => :s3, 
                 :max_size => 500.kilobytes,
                 :resize_to => '300x300>',
                 :thumbnails => {
                   :thumb => [80,80]
                 }

  validates_as_attachment
  validates_presence_of :original_image_url, :if => :no_parent
	validates_format_of :original_image_url, :with => VALID_URL, :on => :create, :allow_nil => true, :if => :no_parent

  def original_image_url=(value)
    write_attribute :original_image_url, value
    unless value.blank?
      begin
        set_from_url(value)
      rescue OpenURI::HTTPError
      end
    end
  end
  
  protected
  
    def no_parent
      !parent_id
    end

end
