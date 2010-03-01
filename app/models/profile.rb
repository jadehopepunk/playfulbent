# == Schema Information
#
# Table name: profiles
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  created_on   :integer(4)
#  welcome_text :text(16777215)
#  published    :boolean(1)
#  disabled     :boolean(1)
#  location_id  :integer(4)
#

class Profile < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  belongs_to :location
  has_one :avatar
  has_one :interests, :dependent => :destroy
  has_one :kinks, :dependent => :destroy
  has_many :photo_sets, :dependent => :destroy, :order => 'position ASC'
  has_many :activity_created_profiles, :dependent => :destroy

  validates_presence_of :user

  before_save :publish_if_has_data
  after_update :save_dependents
  after_create :create_dependents, :create_activity
  before_destroy :destroy_location
  
  def self.popular_ranked_tags(limit)
    TagRank.find(:all, :limit => limit, :order => 'profile_count DESC', :conditions => 'profile_count > 0')
  end
  
  def can_be_edited_by?(other_user)
    !other_user.nil? && other_user == user
  end
  
  def has_avatar?
    !avatar.nil?
  end
  
  def avatar_image_url
    avatar.nil? || disabled? ? Avatar.blank_image_url : avatar.image_url
  end
  
  def avatar_thumb_image_url
    avatar.nil? || disabled? ? Avatar.blank_image_url : avatar.thumb_image_url
  end
  
  def avatar_polaroid_image_url
    avatar.nil? || disabled? ? Avatar.blank_polaroid_image_url : avatar.polaroid_image_url
  end
  
  def avatar_image=(image)
    if image.blank?
      self.avatar.destroy if avatar
    else
      self.avatar = Avatar.new unless avatar
      self.avatar.image = image
      self.avatar.save!
    end
    #avatar = params[:id].blank? ? Avatar.new : Avatar.find(params[:id])
    #avatar.update_attributes params[:avatar]    
  end
  
  def title
    user.name
  end

  def interest_tags
    interests ? interests.tags : []
  end
  
  def interest_tag_string
    interests.tag_list
  end

  def interest_tag_string=(value)
    interests.tag_list = value
  end
  
  def has_interest?(tag)
    interests.has_tag? tag
  end
  
  def has_kink?(tag)
    kinks.has_tag? tag
  end

  def kink_tags
    kinks ? kinks.tags : []
  end
  
  def kink_tag_string
    kinks.tag_list
  end  
  
  def kink_tag_string=(value)
    kinks.tag_list = value
  end  
  
  def update_tags
    all_tags = kinks.tags + interests.tags
    ensure_published unless all_tags.empty?
    #override_tags all_tags.uniq
    tag_list = all_tags.uniq.map(&:name).join(', ')
  end
  
  def owners
    [user]
  end
  
  def url
    user.profile_url if user
  end

  def ensure_published
    unless published
      publish
      save!
    end
  end
  
  def has_gallery_photos?
    GalleryPhoto.find(:first, :include => :photo_set, :conditions => ["photo_sets.profile_id = ?", id])
  end
  
  def to_param
    user.permalink unless user.nil?
  end
  
  def self.find_by_param(value)
    user = User.find_by_permalink(value)
    raise ActiveRecord::RecordNotFound.new if user.nil? || user.profile.nil?
    user.profile
  end
  
  def has_sexuality?
    user && user.has_sexuality?
  end
  
  def gender
    user.gender
  end
  
  def has_gender?
    user && user.has_gender?
  end
  
  def tags_with_spaces
    all_tags = kinks.tags + interests.tags
    return all_tags.map(&:name).join(" ")
  end
  
  def location_name
    location.name if location
  end
  
  def update_location_with(params)
    result = true
    if location
      result = location.update_attributes(params)
      if result && location.contains_no_data?
        self.location.destroy
        self.location = nil
        save
      end
    else
      self.location = Location.new(params)
      result = save unless location.contains_no_data?
    end
    result
  end
  
  def dummy?
    user.dummy?
  end
  
  def default_photo_set
    photo_sets.first
  end

  def photo_sets_to_preview_for(current_user)
    if user == current_user
      photo_sets
    else
      result = photo_sets.find(:all, :conditions => "published = 1", :order => 'position ASC')
      result.select {|photo_set| photo_set.can_be_viewed_by?(current_user) }
    end
  end
  
  def display_photos
    @display_photos || @display_photos = GalleryPhoto.find(:all, :limit => 4, :include => :photo_set, :conditions => ["photo_sets.profile_id = ? AND (photo_sets.viewable_by IS NULL OR photo_sets.viewable_by = 'everyone')", id], :order => 'photo_sets.position, gallery_photos.position')
  end
      
protected

  def publish_if_has_data
    unless published
      if !welcome_text.blank? || has_gender?
        publish
      end
    end
  end

  def create_dependents
    self.interests = Interests.new
    self.kinks = Kinks.new
    self.photo_sets << LocalPhotoSet.new(:title => "#{user.name}'s Photos")
    true
  end 

  def publish
    self.published = true
  end 
  
  def save_dependents
    interests.save! if interests
    kinks.save! if kinks
  end
  
  def destroy_location
    location.destroy if location
    true
  end
  
  def create_activity
    ActivityCreatedProfile.create_for(self)
  end
  
end
