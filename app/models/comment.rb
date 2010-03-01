# == Schema Information
#
# Table name: comments
#
#  id              :integer(4)      not null, primary key
#  content         :text
#  conversation_id :integer(4)
#  user_id         :integer(4)
#  created_at      :datetime
#  parent_id       :integer(4)
#  lft             :integer(4)
#  rgt             :integer(4)
#

class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => :conversation
  
  belongs_to :user
  belongs_to :conversation
  
  validates_presence_of :content, :user, :conversation
  validate_on_create :check_for_recent

  after_create :notify_conversation, :mark_as_read_for_creator
  
  def mark_as_read(reader)
    if !reader.nil? && !reader.new_record? && !read_by(reader)
      CommentReading.create(:user => reader, :comment => self)
    end
  end
  
  def read_by(reader)
    return false if reader.nil? || new_record?
    CommentReading.find(:first, :conditions => {:user_id => reader.id, :comment_id => id}) != nil
  end
  
  def self.to_rss(comments, base_url)
    rss = RSS::Rss.new( "2.0" )
    channel = RSS::Rss::Channel.new
    channel.title = 'Playful Bent - Forums'
    channel.link = base_url + '/conversations'

    for comment in comments
      channel.items << comment.to_rss(base_url)
    end
    rss.channel = channel

    return rss.to_s    
  end
  
  def to_rss(base_url)
    item = RSS::Rss::Channel::Item.new
    item.link = conversation.url
    item.pubDate = created_at
    item.description = user_html_avatar + ' ' + content
    item.title = conversation.title.to_s + ' - comment by ' + user_name
    item
  end
  
  def subject
    conversation.subject if conversation
  end
  
  def subject_type_name
    conversation.subject_type_name if conversation
  end
  
  def subject_url
    conversation.subject_url if conversation
  end
  
  def subject_title
    conversation.subject_title if conversation
  end
  
  def subject_owners
    conversation.subject_owners
  end
  
  def add_reply(reply_comment)
    reply_comment.move_to_child_of(self)
    
    deliver_reply_notification(reply_comment) unless subject_owners.include?(user)
  end
  
  
protected

  def user_name
    user ? user.name : NullUser.new.name
  end

  def user_html_avatar
    user ? user.html_avatar : NullUser.new.html_avatar
  end

  def check_for_recent
    if user
      if self.class.exists?(["user_id = ? AND content = ? AND created_at > ?", user.id, content, 5.minutes.ago])
        errors.add_to_base 'You posted the same comment within the last five minutes. Sometimes this happens because you submitted a comment twice in quick succession. Try refreshing the web page, and your comment is probably already there.'
      end
    end
  end

  def notify_conversation
    conversation.on_new_comment(self)
  end
  
  def mark_as_read_for_creator
    mark_as_read(user)
  end

  def deliver_reply_notification(reply_comment)
    begin
      NotificationsMailer.deliver_new_comment_reply(self, reply_comment)
    rescue Net::SMTPFatalError, Net::SMTPSyntaxError
    end
  end
  
end
