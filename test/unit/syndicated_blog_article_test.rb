# == Schema Information
#
# Table name: syndicated_blog_articles
#
#  id                 :integer(4)      not null, primary key
#  title              :text
#  description        :text
#  published_at       :datetime
#  author             :text
#  link               :text
#  syndicated_blog_id :integer(4)
#  updated_at         :datetime
#  content            :text
#  raw_content        :text
#  raw_description    :text
#

require File.dirname(__FILE__) + '/../test_helper'

class SyndicatedBlogArticleTest < Test::Unit::TestCase
  fixtures :syndicated_blog_articles, :taggings, :tags
  
  BLOGGER_RSS = <<RSS
<?xml version='1.0' encoding='UTF-8'?>
<rss xmlns:atom='http://www.w3.org/2005/Atom' xmlns:openSearch='http://a9.com/-/spec/opensearchrss/1.0/' version='2.0'>
	<channel>
		<atom:id>tag:blogger.com,1999:blog-35972856</atom:id>
		<lastBuildDate>Thu, 29 Mar 2007 17:59:39 +0000</lastBuildDate>
		<title>a mix of bits and pieces</title>	
		<description></description>		
		<link>http://a-mix.blogspot.com/index.html</link>
		<managingEditor>seeker</managingEditor>
		<generator>Blogger</generator>
		<openSearch:totalResults>93</openSearch:totalResults>
		<openSearch:startIndex>1</openSearch:startIndex>  
  	<item>
  		<guid isPermaLink='false'>tag:blogger.com,1999:blog-35972856.post-2827461978804234077</guid>
  		<pubDate>Wed, 28 Mar 2007 17:50:00 +0000</pubDate>
  		<atom:updated>2007-03-29T04:02:00.478+10:00</atom:updated>
  		<category domain='http://www.blogger.com/atom/ns#'>paranoid</category>
  		<category domain='http://www.blogger.com/atom/ns#'>delusion</category>
  		<category domain='http://www.blogger.com/atom/ns#'>united states</category>
  		<category domain='http://www.blogger.com/atom/ns#'>delusional</category>
  		<category domain='http://www.blogger.com/atom/ns#'>paranoia</category>
  		<category domain='http://www.blogger.com/atom/ns#'>usa</category>
  		<title>Paranoid. What do you think?</title>
  		<description>It is good to see from these two articles and the ones they represent that Americans are not paranoid. What, you may ask, these articles were written by an American and they are a good representation of paranoia.&lt;br /&gt;&lt;br /&gt;Well you would be wrong they are not paranoid just delusional. It would be wrong to think they could be paranoid.&lt;br /&gt;&lt;br /&gt;Remember these people need help- do not give them guns or any sort of weapons.&lt;div class="blogger-post-footer"&gt;http://www.askmen.com/feeder/askmenRSS_main.php
  http://suicidegirls.com/rss/photosets/
  http://www.google.com/reader/view/feed/http%3A%2F%2Fsalon.com%2Frss%2Fsalon.rss&lt;/div&gt;</description>
  		<link>http://a-mix.blogspot.com/2007/03/paranoid-what-do-you-think.html</link>
  		<author>seeker</author>
  	</item>
  </channel>
</rss>
RSS
  
  def setup
    @rss_item = tagged_item(['fish', 'banana'])
  end
  
  def tagged_item(name_array)
    result = RSS::Rss::Channel::Item.new
    result.pubDate = 5.days.ago
    result.description = 'some stuff'
    result.title = 'The Dangers of Removing Duplication'
    result.link = 'http://blog.craigambrose.com/articles/2007/03/16/the-dangers-of-removing-duplication'
    result.author = 'Craig'
    result.stubs(:categories).returns(rss_category_array(name_array))
    result
  end
  
  def rss_category(name)
    result = RSS::Rss::Channel::Item::Category.new
    result.content = name
    result
  end
  
  def rss_category_array(name_array)
    name_array.collect {|name| rss_category(name) }
  end

  # TODO
  #
  # def test_rss_article_sets_attributes
  #   article = SyndicatedBlogArticle.new
  #   article.rss_article = @rss_item
  #   assert_equal 'The Dangers of Removing Duplication', article.title
  #   assert_equal 'http://blog.craigambrose.com/articles/2007/03/16/the-dangers-of-removing-duplication', article.link
  #   assert_equal 'Craig', article.author
  #   assert_equal 'some stuff', article.description
  #   assert_equal 5.days.ago.to_date, article.published_at.to_date
  # end
  # 
  # def test_rss_article_sets_tags
  #   article = SyndicatedBlogArticle.create!
  #   article.rss_article = @rss_item
  #   article.save!
  #   article.reload
  #   
  #   assert_equal 'fish, banana', article.tag_list.to_s
  # end
  # 
  # def test_rss_article_clears_previous_tags
  #   article = SyndicatedBlogArticle.create!
  #   article.rss_article = @rss_item
  #   article.save!
  #   article.reload
  #   
  #   article.rss_article = tagged_item(['moose', 'wilderbeast'])
  #   article.save
  #   assert_equal ['moose', 'wilderbeast'], article.tags.collect(&:name)
  # end
  
  def test_setting_raw_content_sets_content
    article = SyndicatedBlogArticle.new
    article.untrusted_content = "fish"
    assert_equal 'fish', article.content
    assert_equal 'fish', article.raw_content
  end
  
  def test_setting_content_strips_out_bad_stuff
    article = SyndicatedBlogArticle.new
    article.untrusted_content = "<p onclick=\"Effect.hide();\">fish</p>"
    assert_equal '<p>fish</p>', article.content
    assert_equal "<p onclick=\"Effect.hide();\">fish</p>", article.raw_content
  end
  
  def test_blogger_rss
    rss = RSS::Parser.parse(BLOGGER_RSS, false)
    
    article = SyndicatedBlogArticle.new
    article.rss_article = rss.items[0]
    assert_equal "It is good to see from these two articles and the ones they represent that Americans are not paranoid. What, you may ask, these articles were written by an American and they are a good representation of paranoia.<br /><br />Well you would be wrong they are not paranoid just delusional. It would be wrong to think they could be paranoid.<br /><br />Remember these people need help- do not give them guns or any sort of weapons.", article.description
  end
  
  def test_to_rss_returns_something
    result = syndicated_blog_articles(:sca_invades).to_rss('http://www.playfulbent.com/blogs/')
    assert result
  end
  
  def test_to_rss_returns_something_if_article_has_no_content
    article = syndicated_blog_articles(:sca_invades)
    article.description = article.content = nil
    result = article.to_rss('http://www.playfulbent.com/blogs/')
    assert result
  end
  
end
