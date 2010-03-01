# == Schema Information
#
# Table name: strip_shows
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  finished     :boolean(1)
#  title        :string(255)
#  published_at :datetime
#

class StripShow < ActiveRecord::Base
  belongs_to :user
  
  has_many :strip_photos, :order => "position", :dependent => :destroy
  has_many :strip_show_views, :dependent => :destroy
  has_one :first_photo, :class_name => 'StripPhoto', :foreign_key => :strip_show_id, :conditions => "position = 1"
  has_many :activity_created_strip_shows, :dependent => :destroy
  
  validates_presence_of :user
  
  PHOTOS_IN_SET = 15
  
  def self.find_for_mixed_genders(limit)
    options = {}
    options[:limit] = limit / 2
    options[:include] = :user
    options[:conditions] = "strip_shows.finished = 1 AND users.gender_id = 1"
    options[:order] = 'strip_shows.published_at DESC, strip_shows.id DESC'
    first_set = StripShow.find(:all, options)
    
    options[:limit] = limit - options[:limit]
    options[:conditions] = "strip_shows.finished = 1 AND users.gender_id != 1"
    second_set = StripShow.find(:all, options)
    (first_set + second_set).sort_by { rand }
  end
  
  def thumb_url
    first_photo.image_thumb_url unless strip_photos.empty?
  end
  
  def first_photo
    strip_photos.first
  end

  def self.find_for_user(find_id, find_user)
    result = StripShow.find(find_id)
    return (result.user == find_user ? result : nil)
  end

  def self.find_all_published
    StripShow.find(:all, :conditions => "finished = 1 AND user_id NOT IN (SELECT user_id FROM profiles WHERE disabled = 1)", :order => 'published_at DESC, id DESC')
  end
  
  def published?
    !published_at.nil?
  end

  def publish
    self.finished = true
    self.published_at = Time.now
    first_photo.publish
    ActivityCreatedStripShow.create_for(self)
  end

  def photo_at_position(position)
    strip_photos.at(position - 1)
  end

  def greatest_position_visible_to(other_user)
    user.greatest_stripshow_position_visible_to(other_user)
  end

  def greatest_position_viewed_by(other_user)
    return 0 if other_user.nil? || other_user.new_record?
    
    show_view = StripShowView.find_by_strip_show_and_user(self, other_user)
    show_view ? show_view.max_position_viewed : 0
  end
  
  def number_viewed_by(other_user)
    greatest_position_viewed_by(other_user)
  end
  
  def all_viewed_by(other_user)
    number_viewed_by(other_user) == PHOTOS_IN_SET
  end
  
  def some_viewed_by(other_user)
    number_viewed_by(other_user) > 0
  end
  
  def number_unviewed_by_and_available_to(other_user)
    number_availabe_to(other_user) - number_viewed_by(other_user)
  end
  
  def number_availabe_to(other_user)
    return 1 if other_user.nil? || other_user.new_record?
    [greatest_position_visible_to(other_user) - 1, 2].max
  end

  def photo_before_next_unviewed(other_user)
    strip_photos.reverse.each do |photo|
      return photo if photo.has_been_viewed_by(other_user)
    end
    nil
  end
  
  def registered_viewers_count
    @count = strip_photos[1].registered_viewers_count unless @count != nil || strip_photos[1] == nil
    @count
  end
  
  def owned_by(some_user)
    user != nil && user == some_user
  end  
  
  def has_all_photos?
    strip_photos.length == PHOTOS_IN_SET
  end
  
  def disabled?
    user && user.disabled?
  end

end
