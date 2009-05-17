# == Schema Information
# Schema version: 258
#
# Table name: conversations
#
#  id             :integer(11)   not null, primary key
#  title_override :string(255)   
#  created_at     :datetime      
#  subject_id     :integer(11)   
#  subject_type   :string(255)   
#

class Conversation < ActiveRecord::Base
  has_many :comments
  belongs_to :subject, :polymorphic => true

  validates_presence_of :title, :if => Proc.new { |c| c.subject.nil? }
  validates_uniqueness_of :subject_type, :scope => :subject_id, :if => Proc.new { |c| !c.subject.nil? }
  
  named_scope :forum, :conditions => 'subject_id IS NULL'
  
  def self.find_for(subject, subject_class_name = nil)
    find(:first, :conditions => {:subject_id => subject.id, :subject_type => subject_class_name || subject.class.name}) unless subject.nil?
  end
  
  def self.find_by_subject_id_and_subject_type(subject_id, subject_type)
    find(:first, :conditions => {:subject_id => subject_id, :subject_type => subject_type}) unless subject_id.blank? || subject_type.blank?
  end
  
  def set_subject(new_subject_id, new_subject_type)
    self.subject = new_subject_id.nil? ? nil : new_subject_type.constantize.find(new_subject_id)
  end
  
  def url
    if subject_url.blank?
      "http://#{ActionController::UrlWriter.default_url_options[:host]}/conversations/#{id}/comments"
    else
      subject_url
    end
  end
  
  def subject_url
    subject.url if subject && subject.respond_to?(:url)
  end
  
  def title=(value)
    title_override = value
  end
  
  def title
    if title_override.blank? && !subject.nil?
      owner_string = subject_owner.nil? ? 'a' : "#{subject_owner.name}'s"
      "Conversation about #{owner_string} #{subject.class.name.titleize}"
    else
      title_override
    end
  end
  
  def subject_based_title
    if title_override.blank? && !subject.nil?
      owner_string = subject_owner.nil? ? 'a' : "#{subject_owner.name}'s"
      "#{owner_string} #{subject.class.name.titleize}"
    else
      title_override
    end
  end
  
  def subject_title
    subject.title if subject && subject.respond_to?(:url)
  end
  
  def comment_text
    comments.empty? ? nil : comments.first.content
  end

  def comment_text=(value)
    ensure_first_comment_exists
    comments.first.content = value
  end
  
  def user=(value)
    ensure_first_comment_exists
    comments.first.user = value
  end
  
  def comment_count
    comments.length
  end
  
  def new_comment_count(reader)
    return 0 if reader.nil? || reader.new_record?
    comment_count - read_comments_count(reader)
  end
  
  def read_comments_count(reader)
    return 0 if reader.nil?
    CommentReading.count(:conditions => ['comment_readings.user_id = ? AND comments.conversation_id = ?', reader.id, id], :include => :comment)
  end
  
  def mark_as_read(reader)
    unless reader.nil? || reader.new_record?
      for comment in comments
        comment.mark_as_read(reader)
      end
    end
  end
  
  def to_rss(base_url)
    rss = RSS::Rss.new( "2.0" )
    channel = RSS::Rss::Channel.new
    channel.title = title
    channel.link = base_url + "/conversations"

    recent_comments = comments.find(:all, :limit => 10, :order => 'created_at DESC')
    for comment in recent_comments
      channel.items << comment.to_rss(base_url)
    end
    rss.channel = channel

    return rss.to_s
  end
  
  def on_new_comment(comment)
    if !subject.nil? && subject.respond_to?(:owners)
      for recipient in subject_owners
        begin
          NotificationsMailer.deliver_new_comment(recipient, comment)
        rescue Net::SMTPFatalError, Net::SMTPSyntaxError
        end
      end
    end
  end
  
  def subject_type_name
    subject.class.name.titleize
  end
  
  def root_comments
    Comment.roots(:conditions => {:conversation_id => id}, :order => 'created_at ASC') if id
  end
  
  def all_comments
    results = []
    for comment in root_comments
      results << comment
      results += comment.all_children
    end
    results
  end
    
  def subject_owners
    subject && subject.respond_to?(:owners) ? subject.owners : []
  end

  def subject_owner
    subject_owners.first
  end

protected

  def ensure_first_comment_exists
    if comments.empty?
      comments << Comment.new(:conversation => self)
    end
  end
  
end
