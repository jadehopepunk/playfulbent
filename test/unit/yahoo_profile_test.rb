require File.dirname(__FILE__) + '/../test_helper'

class YahooProfileTest < Test::Unit::TestCase
  fixtures :yahoo_profiles, :group_memberships, :groups, :users, :email_addresses

  def test_profile_url
    assert_equal '/yahoo_profiles/1', yahoo_profiles(:emlyn).profile_url
  end
  
  def test_that_profile_url_is_user_profile_url_if_profile_is_claimed
    assert_equal 'http://frodo.test.host', yahoo_profiles(:frodo).profile_url
  end
  
  def test_name_is_identifier
    assert_equal 'emlyn23', yahoo_profiles(:emlyn).name
  end
  
  def test_yahoo_profiles_arent_sponsors
    assert_equal false, yahoo_profiles(:emlyn).can_access_sponsor_features?
  end

  def test_that_scrape_asks_scraper_for_image_url
    scraper = Yahoo::Scraper.new(AppConfig.yahoo_scraper_account)
    scraper.expects(:scrape_profile)
    Yahoo::Scraper.stubs(:new).returns(scraper)
    
    profile = yahoo_profiles(:emlyn)
    profile.scrape
  end
  
  def test_that_scrape_if_expired_scrapes_if_scraped_at_is_nil
    profile = yahoo_profiles(:emlyn)
    profile.expects(:scrape)
    
    profile.scrape_if_expired
  end
  
  def test_that_scape_if_expired_scrapes_if_scraped_at_is_greater_than_one_week
    profile = yahoo_profiles(:emlyn)
    profile.scraped_at = 8.days.ago
    profile.expects(:scrape)
    
    profile.scrape_if_expired
  end
  
  def test_that_scrape_if_expired_doesnt_scrape_if_scraped_at_is_less_than_one_week
    profile = yahoo_profiles(:emlyn)
    profile.scraped_at = 6.days.ago
    profile.expects(:scrape).never
    
    profile.scrape_if_expired
  end
  
  def test_that_scrape_if_expired_is_called_on_create
    profile = YahooProfile.new(:identifier => 'valid')
    profile.expects(:scrape)
    
    profile.save!
  end
  
  def test_that_destroying_yahoo_profile_destroys_its_group_memberships
    assert GroupMembership.exists?(1)
    yahoo_profiles(:frodo).destroy
    assert !GroupMembership.exists?(1)
  end
  
  # def test_that_tags_can_be_set_on_unsaved_profile
  #   profile = YahooProfile.new
  #   profile.tag_list 'one, two, three'
  #   assert_equal ['one', 'two', 'three'], profile.tags
  # end
  
  
end
