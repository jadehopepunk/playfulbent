require File.dirname(__FILE__) + '/../test_helper'
require 'open-uri'

class SyndicatedBlogTest < Test::Unit::TestCase
  fixtures :syndicated_blogs

  RSS_URL = 'http://blog.craigambrose.com/xml/rss20/feed.xml'
  HTML_URL = 'http://blog.craigambrose.com'
  VALID_RSS = <<RSS
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/css" href="/stylesheets/rss.css"?>
<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/">
  <channel>
    <title>Craig Ambrose</title>
    <link>http://blog.craigambrose.com/</link>
    <language>en-us</language>
    <ttl>40</ttl>
    <description>Agile Web Development</description>
    <item>
      <title>The Dangers of Removing Duplication</title>
      <description>some stuff</description>
      <pubDate>Fri, 16 Mar 2007 20:13:00 +0000</pubDate>
      <guid isPermaLink="false">urn:uuid:53bfec4f-ba18-4ddb-bf3d-7b5f9f2ef194</guid>
      <author>Craig</author>
      <link>http://blog.craigambrose.com/articles/2007/03/16/the-dangers-of-removing-duplication</link>
      <category>tips</category>
      <category>refactoring</category>
      <category>smells</category>
      <category>helper</category>
    </item>
  </channel>
</rss>
RSS
  
  RSS_WITHOUT_TITLE = <<RSS
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/css" href="/stylesheets/rss.css"?>
<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/">
  <channel>
    <link>http://blog.craigambrose.com/</link>
    <language>en-us</language>
    <ttl>40</ttl>
    <description>Agile Web Development</description>
    <item>
      <title>The Dangers of Removing Duplication</title>
      <description>some stuff</description>
      <pubDate>Fri, 16 Mar 2007 20:13:00 +0000</pubDate>
      <guid isPermaLink="false">urn:uuid:53bfec4f-ba18-4ddb-bf3d-7b5f9f2ef194</guid>
      <author>Craig</author>
      <link>http://blog.craigambrose.com/articles/2007/03/16/the-dangers-of-removing-duplication</link>
      <category>tips</category>
      <category>refactoring</category>
      <category>smells</category>
      <category>helper</category>
    </item>
  </channel>
</rss>
RSS
  
  VALID_HTML = <<HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Craig Ambrose</title>
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />

  <link rel="EditURI" type="application/rsd+xml" title="RSD" href="http://blog.craigambrose.com/xml/rsd" />
  <link rel="alternate" type="application/atom+xml" title="Atom" href="http://blog.craigambrose.com/xml/atom/feed.xml" />
  <link rel="alternate" type="application/rss+xml" title="RSS" href="http://blog.craigambrose.com/xml/rss20/feed.xml" />  
</head>
<body>
</body>
</html>
HTML

  INVALID_RSS_URL = 'invalidurl'

  HTML_WITH_INVALID_RSS_URL = <<HTML
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <link rel="alternate" type="application/rss+xml" title="RSS" href="invalidurl" />  
  </head>
  <body>
  </body>
  </html>
HTML
  
  SOME_URL = 'http://www.somefeed.com'
  
  def setup
    @syndicated_blog = SyndicatedBlog.new
  end

  def test_feed_source_url_and_title_are_loaded_if_valid
    feed_source = FeedFetcher::FeedSource.new('http:/www.goodresult.com', 'the title')
    
    FeedFetcher::FeedFetcher.stubs(:get_feed_source).returns(feed_source)
    @syndicated_blog.site_url = SOME_URL
    @syndicated_blog.valid?
    
    assert_equal 'http:/www.goodresult.com', @syndicated_blog.feed_url
    assert_equal 'the title', @syndicated_blog.title
  end

  def test_no_feed_for_page_error_causes_validation_error    
    FeedFetcher::FeedFetcher.stubs(:get_feed_source).raises(FeedFetcher::NoFeedForPageError)
    @syndicated_blog.site_url = SOME_URL
    @syndicated_blog.valid?
    
    assert_equal nil, @syndicated_blog.feed_url
    assert_equal "Sorry, we couldn't find a feed for this URL. Your blog needs to have a RSS feed facility for us to use it on Playful Bent.", @syndicated_blog.errors[:base]
  end
    
  def test_page_feed_error_causes_validation_error
    FeedFetcher::FeedFetcher.stubs(:get_feed_source).raises(FeedFetcher::PageFeedError)
    @syndicated_blog.site_url = SOME_URL
    @syndicated_blog.valid?
    
    assert_equal nil, @syndicated_blog.feed_url
    assert_equal "You blog has a RSS feed, which is great. However, it doesn't work for us right now, which is less great. Sorry, this wont work.", @syndicated_blog.errors[:base]
  end
  
  def test_page_doesnt_exist_error_causes_validation_error
    FeedFetcher::FeedFetcher.stubs(:get_feed_source).raises(FeedFetcher::PageDoesntExistError)
    @syndicated_blog.site_url = SOME_URL
    @syndicated_blog.valid?
    
    assert_equal nil, @syndicated_blog.feed_url
    assert_equal "Are you sure you typed that right? We just tried to fetch that URL and we couldn't find anything there at all.", @syndicated_blog.errors[:base]
  end
  
  # def test_fetch_updates_gets_articles_from_feed_source
  #   @syndicated_blog.fetch_updates
  # end

end
