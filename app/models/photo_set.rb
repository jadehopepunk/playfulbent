# == Schema Information
# Schema version: 258
#
# Table name: photo_sets
#
#  id              :integer(11)   not null, primary key
#  profile_id      :integer(11)   
#  title           :string(255)   
#  position        :integer(11)   
#  viewable_by     :string(255)   
#  minimum_ticks   :integer(11)   
#  published       :boolean(1)    
#  type            :string(255)   
#  flickr_set_name :string(255)   
#  flickr_set_id   :string(255)   
#  flickr_set_url  :string(255)   
#  last_fetched_at :datetime      
#  version         :integer(11)   default(1)
#

class PhotoSet < ActiveRecord::Base
  VIEWABLE_OPTIONS = [['Everyone', ''], ['My Friends', 'friends'], ['Just Me', 'me']] # ['People I Interact With', 'interactions']
  
  attr_accessor :password
  
  acts_as_list :scope => :profile_id  
  belongs_to :profile
  has_many :gallery_photos, :dependent => :destroy, :order => 'position ASC'
  
  validates_presence_of :profile
  validates_presence_of :title
  validates_length_of :title, :maximum => 255, :allow_nil => true
  validate :default_photo_set_validation
  
  before_save :set_default_viewable_by
  before_destroy :halt_if_default
  
  def display_photo
    gallery_photos.first
  end
  
  def photo_count
    gallery_photos.count
  end
  
  def user
    profile.user
  end
  
  def to_param
    "#{id}-#{PermalinkFu.escape(title)}"
  end
  
  def is_default?
    self == profile.default_photo_set
  end
  
  def ensure_published
    update_attribute(:published, true) unless published
  end
  
  def on_photo_destroyed
    if gallery_photos(true).empty?
      update_attribute(:published, false)
    end
  end
  
  def public?
    viewable_by == 'everyone' || viewable_by.blank?
  end
  
  def can_be_viewed_by?(viewing_user)
    public? || (viewing_user && ((viewable_by == 'me' && viewing_user == user) || (viewable_by == 'friends' && (user == viewing_user || user.relationship_with(viewing_user)))))
  end
  
  def type_name
    self.class.name
  end
  
  def gallery_photo_tag_ranks  
    Tag.rank_tags(gallery_photo_tags)
  end
  
  def gallery_photo_tags
    result = []
    for gallery_photo in gallery_photos
      result += gallery_photo.tags
    end
    result
  end  
  
  def local?
    false
  end
  
  def performing_first_import?
    false
  end
  
  protected
  
    def set_default_viewable_by
      self.viewable_by = 'everyone' if viewable_by.blank?
      true
    end
    
    def default_photo_set_validation
      if is_default? && !public?
        errors.add :viewable_by, "must be everyone on your default photo set"
      end
    end
    
    def halt_if_default
      !is_default?
    end
  
  
end
