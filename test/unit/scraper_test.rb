require File.dirname(__FILE__) + '/../unit_test_helper'

class ScraperTest < Test::Unit::TestCase
  fixtures :yahoo_profiles, :taggings, :tags
  
  def setup
    @page_fetcher = Yahoo::MockPageFetcher.new
    @scraper = Yahoo::Scraper.new(AppConfig.yahoo_scraper_account, @page_fetcher)
    
    @emlyn = yahoo_profiles(:emlyn)
    @emlyn.stubs(:fetch_image_if_specified)
  end
  
  #----------------------------------------------------------
  # SCRAPE PROFILE
  #----------------------------------------------------------
  
  def test_that_scrape_profile_sets_viewable_on_yahoo_to_true_if_a_profile_was_found
    @page_fetcher.stubs(:user_profile).with('emlyn23').returns(emlyns_profile_page)
    
    @scraper.scrape_profile(@emlyn)
    
    assert_equal true, @emlyn.viewable_on_yahoo?
    assert @emlyn.scraped_at >= 2.seconds.ago
  end

  def test_that_scrape_profile_sets_viewable_on_yahoo_to_false_if_a_profile_was_not_found
    @emlyn.viewable_on_yahoo = true
    @page_fetcher.stubs(:user_profile).with('emlyn23').returns(nil)
    
    @scraper.scrape_profile(@emlyn)
    
    assert_equal false, @emlyn.viewable_on_yahoo?
    assert @emlyn.scraped_at >= 2.seconds.ago
  end
  
  def test_that_scrape_profile_sets_tag_string_from_hobbies
    @page_fetcher.stubs(:user_profile).with('emlyn23').returns(emlyns_profile_page)
    @emlyn.expects(:tag_string=).with('Community development, community currency, environmentalism, anarchism, ecovillages, cohousing, programming, weight training.')
    
    @scraper.scrape_profile(@emlyn)
  end
  
  def test_that_scrape_profile_sets_image_url
    @page_fetcher.stubs(:user_profile).with('emlyn23').returns(emlyns_profile_page)
    @emlyn.expects(:image_to_fetch=).with('http://us.f2.yahoofs.com/users/4306a5e1z572453b1/emlyn23/__sr_/cfe9.jpg?pfumutGB27_MEFPT')
    
    @scraper.scrape_profile(@emlyn)
  end
  
  #----------------------------------------------------------
  # CHECK LOGIN
  #----------------------------------------------------------

  def test_that_check_login_returns_false_if_login_fails
    @page_fetcher.stubs(:login_response_page).with('emlyn23', 'sdfdsfsdfghf').returns(login_failed_page)
    assert !@scraper.check_login('emlyn23', 'sdfdsfsdfghf')
  end
  
  def test_that_check_login_returns_false_if_no_page_found
    @page_fetcher.stubs(:login_response_page).with('emlyn23', 'sdfdsfsdfghf').returns(nil)
    assert !@scraper.check_login('emlyn23', 'sdfdsfsdfghf')
  end
  
  def test_that_check_login_returns_true_if_valid_yahoo_page_returned
    @page_fetcher.stubs(:login_response_page).with('emlyn23', 'sdfdsfsdfghf').returns(my_yahoo_homepage_page)
    assert @scraper.check_login('emlyn23', 'sdfdsfsdfghf')
  end

  #----------------------------------------------------------
  # POPULATE GROUP DATA
  #----------------------------------------------------------
  
  def test_that_populate_group_data_sets_minimum_access_levels_if_nothing_found
    @page_fetcher.stubs(:group_page).with('craigsplayground').returns(nil)
    @page_fetcher.stubs(:group_page_as_member).with('craigsplayground', 'playfulbent_test_bot', 'bootlace').returns(nil)
    group_data = GroupData.new
    @scraper.populate_group_data('craigsplayground', group_data)
    
    assert_equal nil, group_data.archive_access_level
    assert_equal nil, group_data.members_list_access_level
  end
  
  def test_that_populates_group_data_sets_permissions_as_stranger
    @page_fetcher.stubs(:group_page).with('craigsplayground').returns(craigsplayground_as_stranger_page)
    @page_fetcher.stubs(:group_page_as_member).with('craigsplayground', 'playfulbent_test_bot', 'bootlace').returns(nil)
    group_data = GroupData.new
    @scraper.populate_group_data('craigsplayground', group_data)
    
    assert_equal 'off', group_data.archive_access_level
    assert_equal 'off', group_data.members_list_access_level
  end
  
  def test_that_populates_group_data_sets_permissions_as_member
    @page_fetcher.stubs(:group_page).with('craigsplayground').returns(craigsplayground_as_stranger_page)
    @page_fetcher.stubs(:group_page_as_member).with('craigsplayground', 'playfulbent_test_bot', 'bootlace').returns(craigsplayground_as_member_page)
    group_data = GroupData.new
    @scraper.populate_group_data('craigsplayground', group_data)
    
    assert_equal 'members', group_data.archive_access_level
    assert_equal 'members', group_data.members_list_access_level
  end
  
  def test_that_populates_group_data_sets_access_to_anyone_if_has_access_when_not_logged_in
    @page_fetcher.stubs(:group_page).with('craigsplayground').returns(craigsplayground_as_member_page)
    @page_fetcher.stubs(:group_page_as_member).with('craigsplayground', 'playfulbent_test_bot', 'bootlace').returns(craigsplayground_as_member_page)
    group_data = GroupData.new
    @scraper.populate_group_data('craigsplayground', group_data)
    
    assert_equal 'anyone', group_data.archive_access_level
    assert_equal 'anyone', group_data.members_list_access_level
  end
  
  def test_that_populate_group_data_sets_member_count
    @page_fetcher.stubs(:group_page).with('craigsplayground').returns(craigsplayground_as_stranger_page)
    @page_fetcher.stubs(:group_page_as_member).with('craigsplayground', 'playfulbent_test_bot', 'bootlace').returns(craigsplayground_as_member_page)
    group_data = GroupData.new
    @scraper.populate_group_data('craigsplayground', group_data)
    
    assert_equal 5, group_data.external_member_count
  end

  #----------------------------------------------------------
  # USER BELONGS TO GROUP
  #----------------------------------------------------------
  
  def test_that_user_belongs_to_group_raises_assertion_if_username_is_blank
    assert_raises(ArgumentError) do
      @scraper.user_belongs_to_group?(nil, 'password', 'craigsplayground')
    end
  end

  def test_that_user_belongs_to_group_raises_assertion_if_password_is_blank
    assert_raises(ArgumentError) do
      @scraper.user_belongs_to_group?('emlyn', nil, 'craigsplayground')
    end
  end

  def test_that_user_belongs_to_group_raises_assertion_if_group_name_is_blank
    assert_raises(ArgumentError) do
      @scraper.user_belongs_to_group?('emlyn', 'password', nil)
    end
  end
  
  def test_that_user_belongs_to_group_returns_false_if_cant_login
    @page_fetcher.stubs(:group_page_as_user).with('craigsplayground', 'emlyn', 'sdfdsfsdfghf').returns(craigsplayground_as_stranger_page)
    
    assert !@scraper.user_belongs_to_group?('emlyn', 'sdfdsfsdfghf', 'craigsplayground')
  end
  
  def test_that_user_belongs_to_group_returns_false_if_can_login_but_doesnt_belong_to_group
    @page_fetcher.stubs(:group_page_as_user).with('craigsplayground', 'emlyn', 'mypassword').returns(craigsplayground_as_stranger_page)
    
    assert !@scraper.user_belongs_to_group?('emlyn', 'mypassword', 'craigsplayground')
  end
  
  def test_that_user_belongs_to_group_returns_false_if_can_login_but_group_page_returns_nil
    @page_fetcher.stubs(:group_page_as_user).with('craigsplayground', 'emlyn', 'mypassword').returns(nil)
    
    assert !@scraper.user_belongs_to_group?('emlyn', 'mypassword', 'craigsplayground')
  end
  
  def test_that_user_belongs_to_group_returns_true_if_can_login_and_belongs_to_group
    @page_fetcher.stubs(:group_page_as_user).with('craigsplayground', 'emlyn', 'mypassword').returns(craigsplayground_as_member_page)
    
    assert @scraper.user_belongs_to_group?('emlyn', 'mypassword', 'craigsplayground')
  end

  protected
  
    def emlyns_profile_page
      load_page :emlyns_profile
    end
    
    def login_failed_page
      load_page :login_failed
    end

    def my_yahoo_homepage_page
      load_page :my_yahoo_homepage
    end
    
    def craigsplayground_as_member_page
      load_page :craigsplayground_as_member
    end
        
    def craigsplayground_as_stranger_page
      load_page :craigsplayground_as_stranger
    end

    def load_page(name)
      File.open(RAILS_ROOT + "/test/fixtures/web_pages/yahoo/#{name}.html").read
    end
    
end
