# == Schema Information
# Schema version: 258
#
# Table name: syndicated_blogs
#
#  id       :integer(11)   not null, primary key
#  title    :string(255)   
#  feed_url :string(255)   
#  user_id  :integer(11)   
#

class SyndicatedBlog < ActiveRecord::Base
  belongs_to :user
  has_many :syndicated_blog_articles, :dependent => :destroy
  attr_accessor :site_url
  
  validates_presence_of :user, :site_url
  validates_uniqueness_of :user_id, :message => 'already has a blog'
  
  before_validation :grab_feed_details
  after_create :fetch_updates
  validate :check_feed_url
  
  def can_be_edited_by?(other_user)
    user && (user == other_user || other_user.is_admin?)
  end
  
  def fetch_updates
    for rss_article in fetch_rss_items
      create_or_update_article(rss_article)
    end
  end
  
  def re_fetch_updates    
    for rss_article in fetch_rss_items
      create_or_update_article(rss_article, true)
    end
  end
  
  def feed_source
    FeedFetcher::FeedSource.new(feed_url) if feed_url
  end
  
protected

  def fetch_rss_items
    source = feed_source
    return [] unless source
    begin
      articles = source.articles
    rescue FeedFetcher::FeedSourceError
    end
    articles ? articles : []
  end

  def create_or_update_article(rss_article, force = false)
    existing_article = syndicated_blog_articles.find_by_link(rss_article.link)
    if existing_article
      if force || existing_article.older_than?(rss_article.pubDate)
        existing_article.rss_article = rss_article
        existing_article.save!
      end
    else
      new_article = syndicated_blog_articles.build(:rss_article => rss_article)
      new_article.save!
    end
  end

  def grab_feed_details
    if !site_url.blank?
      begin
        result = FeedFetcher::FeedFetcher.get_feed_source(site_url)
        if result
          self.feed_url = result.url
          self.title = result.title
        end
      rescue FeedFetcher::NoFeedForPageError
        @feed_error = "Sorry, we couldn't find a feed for this URL. Your blog needs to have a RSS feed facility for us to use it on Playful Bent."
      rescue FeedFetcher::PageFeedError
        @feed_error = "You blog has a RSS feed, which is great. However, it doesn't work for us right now, which is less great. Sorry, this wont work."
      rescue FeedFetcher::PageDoesntExistError
        @feed_error = "Are you sure you typed that right? We just tried to fetch that URL and we couldn't find anything there at all."
      end 
    end
  end
    
  def check_feed_url
    if @feed_error
      errors.add_to_base @feed_error
    end
  end
    
end
