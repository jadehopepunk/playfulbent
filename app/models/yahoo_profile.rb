# == Schema Information
# Schema version: 258
#
# Table name: yahoo_profiles
#
#  id                :integer(11)   not null, primary key
#  identifier        :string(255)   
#  user_id           :integer(11)   
#  created_at        :datetime      
#  updated_at        :datetime      
#  scraped_at        :datetime      
#  viewable_on_yahoo :boolean(1)    
#

class YahooProfile < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  has_many :group_memberships, :dependent => :destroy
  has_one :external_profile_photo, :dependent => :destroy
  
  validates_presence_of :identifier
  validates_length_of :identifier, :maximum => 255
  validates_uniqueness_of :identifier
  
  before_create :scrape_if_expired
  after_create :fetch_image_if_specified
  
  attr_writer :image_to_fetch
  
  def name
    claimed? ? user.name : identifier
  end
  
  def profile_url
    claimed? ? user.profile_url : "/yahoo_profiles/#{to_param}"
  end
  
  def can_access_sponsor_features?
    false
  end
  
  def avatar_thumb_image_url
    image_thumb_url
  end
  
  def image_url
    claimed? ? user.avatar_image_url : external_image_url
  end
  
  def image_thumb_url
    claimed? ? user.avatar_thumb_image_url : external_image_url(:thumb)
  end	
  
	def scrape
	  unless identifier.blank?
  	  scraper = Yahoo::Scraper.new(AppConfig.yahoo_scraper_account)
  	  scraper.scrape_profile(self)
  	end
	end
	
	def scrape_if_expired(max_age = 1.week)
	  scrape if scraped_at.nil? || scraped_at < max_age.ago
	  true
	end
	
	def claimed?
	  user
	end
	
	def interest_tags
	  internal_profile ? internal_profile.interest_tags : tags
	end
	
	def kink_tags
	  internal_profile ? internal_profile.kink_tags : []
	end
	
	def internal_profile
	  user.profile if user
	end
	
  def tag_string=(value)
    tag_list = value
  end
  	
	protected
	
    def external_image_url(version = nil)
      external_profile_photo ? external_profile_photo.public_filename(version) : Avatar.blank_image_url
    end
    
    def fetch_image_if_specified
      if @image_to_fetch
        external_profile_photo.destroy if external_profile_photo
        self.external_profile_photo = ExternalProfilePhoto.new
        self.external_profile_photo.set_from_url(@image_to_fetch)
        self.external_profile_photo.save!
      end
      true
    end
      
end
