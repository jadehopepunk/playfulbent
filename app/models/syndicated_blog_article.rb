# == Schema Information
# Schema version: 258
#
# Table name: syndicated_blog_articles
#
#  id                 :integer(11)   not null, primary key
#  title              :text          
#  description        :text          
#  published_at       :datetime      
#  author             :text          
#  link               :text          
#  syndicated_blog_id :integer(11)   
#  updated_at         :datetime      
#  content            :text          
#  raw_content        :text          
#  raw_description    :text          
#

class SyndicatedBlogArticle < ActiveRecord::Base
  acts_as_taggable
  belongs_to :syndicated_blog
  include WhiteListHelper

  #validates_uniqueness_of :link, :scope => :syndicated_blog_id
  
  def self.popular_ranked_tags(limit)
    TagRank.find(:all, :limit => limit, :order => 'blog_article_count DESC', :conditions => 'blog_article_count > 0', :include => :tag)
  end
    
  def rss_article=(value)
    self.title = value.title
    self.link = value.link
    self.author = value.author
    self.published_at = value.pubDate.to_s
    self.untrusted_description = value.description
    self.untrusted_content = value.content_encoded
    self.tag_list = value.categories.map(&:content).join(', ')
  end
  
  def short_content
    content.blank? ? description : content
  end
  
  def untrusted_description=(value)
    self.raw_description = value
    self.description = clean_html(value)
  end
  
  def untrusted_content=(value)
    self.raw_content = value
    self.content = clean_html(value)
  end
  
  def older_than?(value)
    value && (!updated_at || value > updated_at)
  end
  
  def user
    syndicated_blog.user if syndicated_blog
  end
  
  def self.collection_to_rss(title, articles, base_url)
    rss = RSS::Rss.new( "2.0" )
    channel = RSS::Rss::Channel.new
    channel.title = title
    channel.link = base_url + "/blogs"

    for article in articles
      channel.items << article.to_rss(base_url)
    end
    rss.channel = channel

    return rss.to_s    
  end
  
  def to_rss(base_url)
    item = RSS::Rss::Channel::Item.new
    item.link = link
    item.pubDate = published_at
    item.description = html_avatar + (short_content ? short_content : '')
    item.title = title
    item
  end
  
protected

  def html_avatar
    user ? user.html_avatar + ' ': ''
  end

  def clean_html(value)
    if value
      result = white_list(value)
      return remove_blogger_footer(result)
    end
  end
  
  def remove_blogger_footer(value)
    value.gsub(/<div class="blogger-post-footer">[^<]*<\/div>/, '')
  end
  
end
