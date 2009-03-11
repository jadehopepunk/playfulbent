require File.dirname(__FILE__) + '/../unit_test_helper'
require 'page.rb'

class PageTest < Test::Unit::TestCase
  
  def setup
    @parent = PageVersion.new
    @version1 = PageVersion.new
    @version2 = PageVersion.new
    @page = Page.new(@parent, [])
    
    @frodo = User.new(:nick => 'Frodo')
  end

  def test_versions_getter
    versions = [PageVersion.new, PageVersion.new]
    page = Page.new(nil, versions)
    assert_equal versions, page.versions
  end
  
  def test_followed_versions_are_sorted_to_top_if_user_supplied
    sam = User.new

    followed = PageVersion.new
    followed.stubs(:being_followed_by).with(sam).returns(true)
    not_followed = PageVersion.new
    not_followed.stubs(:being_followed_by).with(sam).returns(false)
    
    versions = [not_followed, followed]
    page = Page.new(nil, versions)
    assert_equal [followed, not_followed], page.versions(sam)
  end
    
  def test_page_number_is_one_if_parent_is_nil
    page = Page.new(nil, [])
    assert_equal 1, page.page_number
  end
  
  def test_page_number_is_one_more_than_parent_number
    parent = PageVersion.new
    parent.stubs(:page_number).returns(5)
    page = Page.new(parent, [])
    assert_equal 6, page.page_number
  end
  
  def test_parent_getter
    parent = PageVersion.new
    page = Page.new(parent, [])
    assert_equal parent, page.parent
  end
  
  def test_grandparent_nil_if_parent_is_nil
    page = Page.new(nil, [])
    assert_equal nil, page.grandparent
  end

  def test_grandparent_returns_parents_parent
    parent = Page.new(nil, [])
    parent.stubs(:parent).returns('fish')
    page = Page.new(parent, [])
    assert_equal 'fish', page.grandparent
  end  
  
  def test_authors_returns_authors_from_version_and_parent
    userA = User.new(:nick => 'A')
    userB = User.new(:nick => 'B')
    userC = User.new(:nick => 'C')
    
    version1 = PageVersion.new(:author => userA)
    version2 = PageVersion.new(:author => userB)
    parent = PageVersion.new()
    parent.stubs(:authors).returns([userA, userC])
    
    page = Page.new(parent, [version1, version2])
    assert_equal [userA, userC, userB], page.authors
  end

  def test_cant_have_alternative_if_page_has_no_parent
    assert_equal false, Page.new(nil, []).can_have_alternative?
  end
  
  def test_can_have_alternative_if_page_has_parent
    assert_equal true, Page.new(PageVersion.new, []).can_have_alternative?
  end
  
  def test_followers_defaults_to_empty_array
    assert_equal [], Page.new(nil, []).followers
  end
  
  def test_followers_includes_unique_followers_from_versions
    version1 = PageVersion.new()
    version1.stubs(:followers).returns([1, 4, 8, 5])
    version2 = PageVersion.new()
    version2.stubs(:followers).returns([4, 6, 2, 1])
    version3 = PageVersion.new()
    version3.stubs(:followers).returns([1, 2, 3])
    
    page = Page.new(version3, [version1, version2])
    assert_equal [1, 4, 8, 5, 6, 2], page.followers
  end
  
  def test_being_followed_by_returns_false_by_default
    assert_equal false, Page.new(nil, []).being_followed_by(User.new)
  end
  
  def test_being_followed_by_returns_false_for_nil_user
    assert_equal false, Page.new(nil, []).being_followed_by(nil)
  end
  
  def test_being_followed_by_returns_false_if_versions_not_being_followed
    user = User.new
    
    not_followed = PageVersion.new
    not_followed.stubs(:being_followed_by).with(user).returns(false)
    
    assert_equal false, Page.new(nil, [not_followed, not_followed]).being_followed_by(user)
  end
  
  def test_being_followed_by_returns_true_if_a_versions_is_being_followed
    user = User.new
    
    not_followed = PageVersion.new
    not_followed.stubs(:being_followed_by).with(user).returns(false)
    followed = PageVersion.new
    followed.stubs(:being_followed_by).with(user).returns(true)
    
    assert_equal true, Page.new(nil, [not_followed, followed]).being_followed_by(user)
  end
  
  def test_on_viewed_follows_parent
    @parent.expects(:follow).with(@frodo)
    @page.on_viewed(@frodo)
  end
  
  def test_on_viewed_with_multiple_versions_doesnt_follow_versions
    page = Page.new(nil, [@version1, @version2])

    @version1.expects(:follow).never
    @version2.expects(:follow).never
    
    page.on_viewed(@frodo)
  end
  
  def test_on_viewed_with_parent_not_followed_doesnt_follow_version
    @parent.stubs(:follow)
    @parent.stubs(:being_followed_by).with(@frodo).returns(false)
    @version1.expects(:follow).never
    page = Page.new(@parent, [@version1])
    
    page.on_viewed(@frodo)
  end

  def test_on_viewed_with_no_parent_and_only_one_version_with_follow_that_version
    @version1.expects(:follow).with(@frodo)
    page = Page.new(nil, [@version1])
    
    page.on_viewed(@frodo)
  end
    
  def test_on_viewed_with_parent_being_followed_and_only_one_version_will_follow_that_version
    @parent.stubs(:follow)
    @parent.stubs(:being_followed_by).with(@frodo).returns(true)
    @version1.expects(:follow).with(@frodo)
    page = Page.new(@parent, [@version1])
    
    page.on_viewed(@frodo)
  end
  
  def test_on_viewed_marks_pages_as_read
    page = Page.new(nil, [@version1, @version2])

    @version1.expects(:mark_as_read_by).with(@frodo)
    @version2.expects(:mark_as_read_by).with(@frodo)
    
    page.on_viewed(@frodo)    
  end
  
end
