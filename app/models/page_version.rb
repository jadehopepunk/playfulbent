# == Schema Information
# Schema version: 258
#
# Table name: page_versions
#
#  id         :integer(11)   not null, primary key
#  text       :text          
#  author_id  :integer(11)   
#  parent_id  :integer(11)   
#  story_id   :integer(11)   
#  created_on :datetime      
#  is_end     :boolean(1)    
#

class PageVersion < ActiveRecord::Base
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :story
  has_many :page_version_followers, :dependent => :destroy
  has_many :followers, :through => :page_version_followers
  has_many :activity_continued_story, :dependent => :destroy

  acts_as_tree :order => 'created_on ASC'
  acts_as_taggable

  validates_presence_of :text, :author, :story
  validate :parent_not_end

  after_create :notify_parent, :notify_story, :ensure_interactions_created, :create_activity
  after_save :update_story_tags
  
  def can_be_edited_by?(other_user)
    !other_user.nil? && (author == other_user || other_user.is_admin)
  end
  
  def title
    story.title
  end
  
  def page
    Page.new(self, children)
  end
  
  def first_page?
    !parent
  end
  
  def authors
    result = []
    result += parent.authors unless parent.nil?
    result << author unless author.nil?
    result
  end

  def followers_so_far
    result = []
    result += parent.followers_so_far unless parent.nil?
    result += followers
    result
  end
  
  def page_number
    ancestors.length + 1  
  end
  
  def being_followed_by(user)
    return true if user == author && !user.nil?
    !page_version_followers.find(:first, :conditions => ["user_id = ?", user.id]).nil?
  end
  
  def follow(user)
    unless being_followed_by(user)
      followers << user
      parent.follow(user) unless parent.nil?
    end
  end
  
  def read_by?(reader)
    return false if reader.nil? || reader.new_record?
    return false if new_record?
    PageVersionReading.find(:first, :conditions => {:user_id => reader.id, :page_version_id => id})
  end
  
  def mark_as_read_by(reader)
    return if reader.nil? || reader.new_record?
    return if new_record?
    
    unless read_by?(reader)
      PageVersionReading.create(:user => reader, :page_version => self, :story => story)
    end
  end
  
  def can_stop_following(user)
    user != author && being_followed_by(user)
  end
  
  def stop_following(user)
    followers.delete(user)
    children.each {|child| child.stop_following user}
  end
  
  def has_children?
    !children.empty?
  end
  
  def on_new_child(new_child)
    deliver_if_subscribing(author, new_child, :continue_page_i_wrote)
    for follower in followers
      deliver_if_subscribing(follower, new_child, :continue_page_i_follow)
    end
  end
  
  def owners
    [author]
  end
  
  def url
    "http://#{ActionController::UrlWriter.default_url_options[:host]}/stories/#{story.id}/parent/#{parent ? parent.id : 0}/pages" if story && !story.new_record?
  end
  
protected

  def deliver_if_subscribing(recipient, new_child, check_method)
    subscription = story.subscription_for(recipient)
    begin
      NotificationsMailer.deliver_story_continued(recipient, new_child) if subscription.send(check_method)
    rescue Net::SMTPSyntaxError
    end
  end

  def notify_parent
    parent.on_new_child(self) unless parent.nil?
  end
  
  def notify_story
    story.on_new_page_version
  end
  
  def parent_not_end
    errors.add(:parent, 'page was the end of the story.') if !parent.nil? && parent.is_end
  end
  
  def update_story_tags
    unless story.nil?
      story.update_tags_from_pages
    end
  end
  
  def ensure_interactions_created
    for other_author in story.authors
      unless author == other_author
        InteractionWriteInSameStory.ensure_created(other_author, author)
        InteractionWriteInSameStory.ensure_created(author, other_author)
      end
    end
    true
  end
  
  def create_activity
    ActivityContinuedStory.create_for(self) unless first_page?
  end

end
