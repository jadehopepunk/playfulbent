require File.dirname(__FILE__) + '/../test_helper'
require 'feed_fetcher/feed_fetcher'

class FeedFetcherTest < Test::Unit::TestCase
  
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

  def test_setting_site_url_to_rss_url_sets_feed_url
    FeedFetcher::PageFetcher.stubs(:fetch_page).with(RSS_URL).returns(VALID_RSS)
    result = FeedFetcher::FeedFetcher::get_feed_source(RSS_URL)
    
    assert_equal RSS_URL, result.url
  end

  def test_setting_site_url_to_non_rss_url_doest_set_feed_url
    FeedFetcher::PageFetcher.stubs(:fetch_page).with(RSS_URL).returns('')
    
    assert_raise FeedFetcher::NoFeedForPageError do
      FeedFetcher::FeedFetcher::get_feed_source(RSS_URL)
    end
  end
  
  def test_setting_site_url_to_html_page_fetches_rss_link
    FeedFetcher::PageFetcher.stubs(:fetch_page).with(HTML_URL).returns(VALID_HTML)
    FeedFetcher::PageFetcher.stubs(:fetch_page).with(RSS_URL).returns(VALID_RSS)
    result = FeedFetcher::FeedFetcher::get_feed_source(HTML_URL)
    
    assert_equal RSS_URL, result.url
  end

  def test_fetches_title_from_rss_feed
    FeedFetcher::PageFetcher.stubs(:fetch_page).with(RSS_URL).returns(VALID_RSS)
    result = FeedFetcher::FeedFetcher::get_feed_source(RSS_URL)

    assert_equal 'Craig Ambrose', result.title
  end

  def test_title_is_nil_if_rss_has_no_title
    FeedFetcher::PageFetcher.stubs(:fetch_page).with(RSS_URL).returns(RSS_WITHOUT_TITLE)
    result = FeedFetcher::FeedFetcher::get_feed_source(RSS_URL)
    
    assert_equal nil, result.title
  end
  
  def test_that_site_with_invalid_rss_link_fails_validation
    FeedFetcher::PageFetcher.stubs(:fetch_page).with(HTML_URL).returns(HTML_WITH_INVALID_RSS_URL)
    FeedFetcher::PageFetcher.stubs(:fetch_page).with(INVALID_RSS_URL).returns(nil)
    
    assert_raise FeedFetcher::PageFeedError do
      FeedFetcher::FeedFetcher::get_feed_source(HTML_URL)
    end
  end

  def test_that_html_site_that_doesnt_exist_fails_validation
    FeedFetcher::PageFetcher.stubs(:fetch_page).with(HTML_URL).returns(nil)
    
    assert_raise FeedFetcher::PageDoesntExistError do
      FeedFetcher::FeedFetcher::get_feed_source(HTML_URL)
    end
  end

  def test_setting_site_url_without_protocol_adds_http
    FeedFetcher::PageFetcher.stubs(:fetch_page).with('http://blog.craigambrose.com').returns(VALID_RSS)
    result = FeedFetcher::FeedFetcher::get_feed_source('blog.craigambrose.com')
    
    assert_equal 'http://blog.craigambrose.com', result.url
  end
  
end