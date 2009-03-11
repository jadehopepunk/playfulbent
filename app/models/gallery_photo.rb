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

class GalleryPhoto < ActiveRecord::Base
  acts_as_list :scope => :photo_set_id
  acts_as_taggable
  
  belongs_to :photo_set
  has_many :activity_created_gallery_photos, :dependent => :destroy
  
  validates_length_of :title, :maximum => 255
  validates_presence_of :photo_set

  after_create :inform_profile, :create_activity
  after_destroy :inform_photo_set_of_destroy
  
  def self.popular_ranked_tags(limit)
    TagRank.find(:all, :limit => limit, :order => 'gallery_photo_count DESC', :conditions => 'gallery_photo_count > 0')
  end
  
  def profile
    photo_set.profile if photo_set
  end
  
  def can_be_edited_by?(user)
    profile && profile.can_be_edited_by?(user)
  end
  
  def lower_item_with_tag(tag)
    return lower_item if tag.nil?
    self.class.find(:first, :order => 'position ASC', :conditions => ["photo_set_id = ? AND position > ? AND #{tag.taggable_conditions('GalleryPhoto')}", photo_set.id, position])
  end
  
  def higher_item_with_tag(tag)
    return higher_item if tag.nil?
    self.class.find(:first, :order => 'position DESC', :conditions => ["photo_set_id = ? AND position < ? AND #{tag.taggable_conditions('GalleryPhoto')}", photo_set.id, position])
  end
  
  def owners
    [user]
  end
  
  def user
    profile.user if profile
  end
  
  def to_param
    title.blank? ? id.to_s : "#{id.to_s}-#{PermalinkFu.escape(title)}"
  end
  
  def page_title
    tag_string = tag_list
    if title == 'Untitled' || title.blank?
      photo_name = (tag_string.blank? ? "Untitled Photo" : "Untitled #{tag_string} Photo")
    else
      photo_name = title
    end
    "#{photo_name} by #{user.name} | Playful Bent"
  end
  
  def meta_description
    about_string = " about #{tags.to_sentence}" unless tag_list.blank?
    
    "An erotic photo#{about_string} by #{user.name} on Playful Bent, which offers free, uncensored image hosting for sexual and adult images."
  end
  
  def format
    raise NotImplementedError
  end
  
  def get_file_for_role(role)
    raise NotImplementedError
  end
  
  def viewable_by
    photo_set.viewable_by if photo_set
  end
  
  def public?
    photo_set && photo_set.public?
  end
    
  def can_be_viewed_by?(current_user)
    photo_set && photo_set.can_be_viewed_by?(current_user)
  end
  
  def url
    "http://#{ActionController::UrlWriter.default_url_options[:host]}/users/#{user.to_param}/photo_sets/#{photo_set.to_param}/my_photos/#{to_param}"
  end
  
protected

  def inform_profile
    if photo_set    
      profile.ensure_published
      photo_set.ensure_published
    end
    true
  end
  
  def inform_photo_set_of_destroy
    photo_set.on_photo_destroyed if photo_set
  end
  
  def create_activity
    ActivityCreatedGalleryPhoto.create_for(self)
  end
  
end
