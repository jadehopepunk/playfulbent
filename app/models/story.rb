# == Schema Information
#
# Table name: stories
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  created_on :datetime
#  updated_at :datetime
#

class Story < ActiveRecord::Base
  acts_as_taggable
  
  validates_presence_of :title, :first_page_text, :author

  has_many :page_versions, :dependent => :destroy
  has_many :story_subscriptions
  has_one :first_page_version, :class_name => 'PageVersion', :conditions => "parent_id IS NULL"
  has_many :activity_created_strip_shows, :dependent => :destroy
  
  after_create :create_first_page, :create_activity
  
  def self.popular_ranked_tags(limit)
    TagRank.find(:all, :limit => limit, :order => 'story_count DESC', :conditions => 'story_count > 0')
  end
  
  def version_count
    page_versions.length
  end
  
  def unique_author_count
    authors.uniq.length
  end
  
  def page_version_count
    page_versions.length
  end
  
  def first_page
    Page.new(nil, [first_page_version])
  end
  
  def authors
    page_versions.collect {|version| version.author }
  end
  
  def has_author?(value)
    authors.include? value
  end
  
  def first_page_text
    self.first_page_version.nil? ? '' : self.first_page_version.text
  end
  
  def first_page_text=(value)
    ensure_first_page_exists
    self.first_page_version.text = value
  end
  
  def first_page_tag_list
    self.first_page_version.nil? ? '' : self. first_page_version.tag_list
  end
  
  def first_page_tag_list=(value)
    ensure_first_page_exists
    self.first_page_version.tag_list = value
  end
  
  def author
    self.first_page_version.author unless self.first_page_version.nil?
  end
  
  def author=(value)
    ensure_first_page_exists
    self.first_page_version.author = value
  end
  
  def preferred_chapters(user)
    result = [[first_page_version]]
    result + self.first_page_version.preferred_subsequent_chapters(user)
  end
  
  def subscription_for(user)
    story_subscriptions.find(:first, :conditions => ['user_id = ?', user.id]) || StorySubscription.new
  end
  
  def update_tags_from_pages
    all_tags = []
    for version in page_versions
      all_tags += version.tags
    end
    # override_tags all_tags.uniq
    self.tag_list = all_tags.uniq.map(&:name).join(', ')
    save!
  end
  
  def get_read_leaf_pages_except(viewing_user, except_page = nil)
    return [] if !viewing_user || viewing_user.new_record?
    first_page.get_read_leaf_pages_except(viewing_user, except_page)
  end
  
  def number_unread_by(viewing_user)
    return 0 if new_record?
    return nil if viewing_user.nil? || viewing_user.new_record?
    total_page_version_count - total_page_versions_read_by(viewing_user)
  end
  
  def on_new_page_version
    updated_at = Time.now.to_s(:db)
    save!
  end
    
  def tags_with_spaces
    return self.tags.map(&:name).join(" ")
  end
  
  def to_param
    "#{id}-#{PermalinkFu.escape(title)}"
  end
  
protected

  def total_page_version_count
    PageVersion.count(:conditions => {:story_id => id})
  end
  
  def total_page_versions_read_by(viewing_user)
    PageVersionReading.count(:conditions => {:story_id => id, :user_id => viewing_user})
  end

  def ensure_first_page_exists
    if self.first_page_version.nil?
      self.first_page_version = PageVersion.new
      self.first_page_version.story = self
    end
  end
  
  def create_first_page
    raise "Could not create first page" unless self.first_page_version.save
  end
  
  def create_activity
    ActivityCreatedStory.create_for(self)
  end
  
end
