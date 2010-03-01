# == Schema Information
#
# Table name: products
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#

class Product < ActiveRecord::Base
  VALID_URL = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z0-9]{2,5}(([0-9]{1,5})?\/.*)?$/ix
  CATEGORIES = ['Sex Toy', 'Web Site', 'Book']

  has_one :product_image, :dependent => :destroy
  has_many :product_urls, :dependent => :destroy
  has_many :reviews
  
  validates_presence_of :url
	validates_format_of :url, :with => VALID_URL, :on => :create, :allow_nil => true, :message => "doesn't look like a real web address"
	validates_presence_of :name, :if => :not_step_one
	validate_on_create :validate_not_on_step_one
	validates_associated :product_image, :allow_nil => true
	
	attr_accessor :active_step
	attr_protected :active_step
	
	def self.new_from_category(category, attributes)
	  for possible_class in possible_classes
	    if possible_class.name == category
	      return possible_class.new(attributes)
	    end
	  end
	  return Product.new(attributes)
	end
	
	def self.possible_classes
	  [ProductSexToy, ProductWebSite, ProductBook]
	end
	
	def ready_to_fetch_page?
	  has_valid_type? && has_valid_url?
	end
	
	def url
	  product_urls.first.url if product_urls.first
	end
	
	def url=(value)
	  product_urls.build(:original_url => value)
	end
	
	def image_url
	  product_image.original_image_url if product_image
	end
	
	def image_url=(value)
	  self.product_image = nil if product_image
	  unless value.blank?
	    self.product_image = ProductImage.new
	    self.product_image.original_image_url = value
	  end
	end
	
	def thumbnail_url
	  product_image ? product_image.public_filename(:thumb) : blank_thumbnail_url
	end
	
	def self.human_name
	  name.underscore.humanize.titleize.sub('Product ', '')
	end
	
	def human_name
	  self.class.human_name
	end
	
	def category
	  self.class.name
	end
	
	def possible_images(fetch = true)
    result = []
    result << image_url unless image_url.blank?
    result += ImageFetcher.fetch_images(url).reject {|this_image| this_image == image_url} if fetch && !url.blank?
    result	  
	end
	
	def display_urls
	  product_urls.find(:all, :order => "affiliate_url IS NULL ASC, affiliate_url = '' ASC, created_at ASC")
	end
	  
	protected
	
	  def has_valid_type?
	    self.class != Product
	  end
	  
	  def has_valid_url?
	    !url.blank? && VALID_URL =~ url
	  end
	  
	  def step_one
	    self.active_step.nil? || self.active_step == 1
	  end
	  
	  def not_step_one
	    !step_one
	  end
	  
	  def validate_not_on_step_one
	    if step_one
	      errors.add_to_base "Can't save this item, you are still on step one of the creation process."
	    end
	  end
	  
	  def type_name
	    self.class.name.underscore[8..-1]
	  end
	  
	  def blank_thumbnail_url
	    "http://#{ActionController::UrlWriter.default_url_options[:host]}/images/no_image/#{type_name}.png"
	  end
  
end
