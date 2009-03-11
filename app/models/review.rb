# == Schema Information
# Schema version: 258
#
# Table name: reviews
#
#  id                :integer(11)   not null, primary key
#  user_id           :integer(11)   
#  product_id        :integer(11)   
#  created_at        :datetime      
#  updated_at        :datetime      
#  sexyness_rating   :integer(11)   
#  durability_rating :integer(11)   
#  cleaning_rating   :integer(11)   
#  pleasure_rating   :integer(11)   
#  overall_rating    :integer(11)   
#  body              :text          
#

class Review < ActiveRecord::Base
  RATING_MAX = 5
  RATING_METHODS = [:sexyness, :durability, :cleaning, :pleasure]
  FEATURED_USER = 'curvaceousdee'
  
  acts_as_taggable
  acts_as_textiled :body
  
  belongs_to :user
  belongs_to :product
  has_many :action_shots, :dependent => :destroy
  has_many :activity_created_reviews, :dependent => :destroy
  
  validates_presence_of :user, :product, :overall_rating, :body
  
  after_create :create_activity
  
  def self.find_featured
    featured_user.reviews.find(:first, :order => 'created_at DESC')
  end
  
  def self.featured_user
    User.find_by_permalink(FEATURED_USER)
  end
  
  def self.popular_ranked_tags(limit)
    TagRank.find(:all, :limit => limit, :order => 'review_count DESC', :conditions => 'review_count > 0')
  end
    
  def ratings_with_titles
    RATING_METHODS.map { |method|
      method_name = "#{method}_rating".to_sym
      value = send(method_name)
      [method.to_s.humanize.titleize, value] unless value.nil?
    }.compact
  end
  
  def can_have_action_shots?
    product.is_a?(ProductSexToy)
  end
  
  def title
    "#{product_name} review by #{user.name}"
  end
  
  def product_name
    product.name if product
  end
  
  def product_url
    product.url if product
  end
  
  def display_urls
    product.display_urls if product
  end
  
  def url
    "http://#{ActionController::UrlWriter.default_url_options[:host]}/reviews/#{to_param}"
  end
  
  def owners
    [user]
  end  
      
  protected
  
    def ensure_has_product
      self.product = Product.new
    end
    
    def create_activity
      ActivityCreatedReview.create_for(self)
      true
    end
  
end
