require File.dirname(__FILE__) + '/../test_helper'
require 'feed_fetcher/feed_fetcher'
require 'feed_fetcher/feed_source'

class FeedSourceTest < Test::Unit::TestCase
  
  RSS_URL = 'http://blog.craigambrose.com/xml/rss20/feed.xml'  
  
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
    <item>
      <title>Pagination Using AJAX</title>
      <description>some &lt;strong&gt;bold&lt;/strong&gt; stuff</description>
      <pubDate>Mon, 12 Mar 2007 08:29:00 +0000</pubDate>
      <guid isPermaLink="false">urn:uuid:1e9ce302-029e-4514-a180-17dbaad142d8</guid>
      <author>Craig</author>
      <link>http://blog.craigambrose.com/articles/2007/03/12/pagination-using-ajax</link>
      <category>tips</category>
      <category>helper</category>
      <category>ajax</category>
      <category>pagination</category>
    </item>
  </channel>
</rss>
RSS

  def setup
    @feed_source = FeedFetcher::FeedSource.new(RSS_URL)
  end

  def test_articles_throws_exception_if_url_doesnt_exist
    FeedFetcher::PageFetcher.stubs(:fetch_page).with(RSS_URL).returns(nil)

    assert_raise FeedFetcher::FeedSourceError do
      @feed_source.articles
    end
  end
  
  def test_articles_finds_two_articles
    FeedFetcher::PageFetcher.stubs(:fetch_page).with(RSS_URL).returns(VALID_RSS)
    assert @feed_source.articles
    assert @feed_source.articles.is_a?(Array)
    assert_equal 2, @feed_source.articles.length
    
    assert_equal 'The Dangers of Removing Duplication', @feed_source.articles[0].title
    assert_equal 'some stuff', @feed_source.articles[0].description
  end
  
  def test_calling_articles_twice_only_fetches_once
    FeedFetcher::PageFetcher.expects(:fetch_page).with(RSS_URL).returns(VALID_RSS)
    @feed_source.articles
    @feed_source.articles
  end
  
  def test_calling_reload_fetches_articles_again
    FeedFetcher::PageFetcher.expects(:fetch_page).with(RSS_URL).returns(VALID_RSS).times(2)
    @feed_source.articles
    @feed_source.reload
    @feed_source.articles
  end
  
end
