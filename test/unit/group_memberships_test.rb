require File.dirname(__FILE__) + '/../test_helper'

class GroupMembershipsTest < Test::Unit::TestCase
  fixtures :group_memberships, :groups, :yahoo_profiles, :users, :email_addresses

  def setup
    @craigs_playground = groups(:craigs_playground)
    
    @mock_scraper = Yahoo::MockScraper.new(AppConfig.yahoo_scraper_account)
    Yahoo::Scraper.stubs(:new).returns(@mock_scraper)
  end
  
  #-----------------------------------------------------
  # FETCH FOR
  #-----------------------------------------------------

  def test_that_fetch_for_returns_new_membership_if_params_is_nil
    result = GroupMembership.fetch_for(@craigs_playground, nil)
    assert result
    assert result.new_record?
    assert !result.valid?
    assert_equal @craigs_playground, result.group
    assert_equal nil, result.yahoo_profile
  end

  def test_that_fetch_for_returns_new_membership_if_username_is_blank
    result = GroupMembership.fetch_for(@craigs_playground, :username => '', :password => 'sponk')
    assert result
    assert result.new_record?
    assert !result.valid?
    assert_equal @craigs_playground, result.group
    assert_equal nil, result.yahoo_profile
  end

  def test_that_fetch_for_returns_new_membership_if_password_is_blank
    result = GroupMembership.fetch_for(@craigs_playground, :username => 'fishhead', :password => '')
    assert result
    assert result.new_record?
    assert !result.valid?
    assert_equal @craigs_playground, result.group
    assert_equal nil, result.yahoo_profile
  end
  
  def test_that_fetch_for_raises_exception_if_no_group_provided
    assert_raises(ArgumentError) do
      GroupMembership.fetch_for(nil, nil)
    end
  end
  
  def test_that_fetch_for_returns_existing_membership_if_it_exists_for_username_and_group
    result = GroupMembership.fetch_for(@craigs_playground, :username => 'frodo', :password => 'dfsdfds')
    assert_equal group_memberships(:frodo_craigs_playground), result
  end
  
  def test_that_fetch_for_returns_empty_membership_if_profile_exists_and_scraper_denies_membership
    @mock_scraper.expects(:user_belongs_to_group?).with('notamember', 'mydogsname', 'craigsplayground').returns(false)
    
    result = GroupMembership.fetch_for(@craigs_playground, :username => 'notamember', :password => 'mydogsname')
    assert result
    assert result.new_record?
    assert !result.valid?
    assert_equal @craigs_playground, result.group
    assert_equal nil, result.yahoo_profile
  end
  
  def test_that_fetch_for_returns_new_populated_membership_if_profile_exists_and_scraper_confirms_membership
    @mock_scraper.expects(:user_belongs_to_group?).with('notamember', 'mydogsname', 'craigsplayground').returns(true)
    
    result = GroupMembership.fetch_for(@craigs_playground, :username => 'notamember', :password => 'mydogsname')
    assert result
    assert result.new_record?
    assert result.valid?
    assert_equal @craigs_playground, result.group
    assert_equal yahoo_profiles(:not_a_member), result.yahoo_profile
  end

  def test_that_fetch_for_returns_empty_membership_if_profile_doesnt_exist_and_scraper_denies_membership
    @mock_scraper.expects(:user_belongs_to_group?).with('doesntexist', 'mydogsname', 'craigsplayground').returns(false)
    
    result = GroupMembership.fetch_for(@craigs_playground, :username => 'doesntexist', :password => 'mydogsname')
    assert result
    assert result.new_record?
    assert !result.valid?
    assert_equal @craigs_playground, result.group
    assert_equal nil, result.yahoo_profile
  end

  def test_that_fetch_for_returns_new_populated_membership_if_profile_doesnt_exist_and_scraper_confirms_membership
    @mock_scraper.expects(:user_belongs_to_group?).with('doesntexist', 'mydogsname', 'craigsplayground').returns(true)
    
    result = GroupMembership.fetch_for(@craigs_playground, :username => 'doesntexist', :password => 'mydogsname')
    assert result
    assert result.new_record?
    assert result.valid?
    assert_equal @craigs_playground, result.group
    assert result.yahoo_profile
    assert_equal 'doesntexist', result.yahoo_profile.identifier
  end

  
end
