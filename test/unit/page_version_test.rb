require File.dirname(__FILE__) + '/../test_helper'

class PageVersionTest < Test::Unit::TestCase
  fixtures :stories, :users, :email_addresses, :page_versions, :taggings, :tags, :story_subscriptions, :page_version_followers
  
  def setup
    @frodo = users(:frodo)
    @pippin = users(:pippin)
    @sam = users(:sam)
    @quentin = users(:quentin)
    @bob = users(:bob)
    @story = Story.create!(:title => 'test story', :first_page_text => 'some text', :author => @bob)

    @version = PageVersion.new
    @subscription = StorySubscription.new
  end

  def subscribe_author(story, notify)
    subscribe(story, story.author, notify, false)
  end
  
  def subscribe_follower(story, follower, notify)
    subscribe(story, follower, false, notify)
  end
  
  def subscribe(story, user, notify_author, notify_follower)
    subscription = @story.story_subscriptions.build(:user => user)
    subscription.continue_page_i_wrote = notify_author
    subscription.continue_page_i_follow = notify_follower
    subscription.save!
    user
  end
  
  def test_authors_defaults_to_empty_list
    assert_equal [], PageVersion.new.authors
  end
  
  def test_authors_includes_author_of_this_version
    frodo = User.new(:nick => 'frodo')
    version = PageVersion.new
    version.author = frodo
    assert_equal [frodo], version.authors
  end
  
  def test_authors_includes_author_of_parent_version
    frodo = User.new(:nick => 'frodo')
    bilbo = User.new(:nick => 'bilbo')
    version = PageVersion.new
    version.author = frodo
    parent_version = PageVersion.new
    parent_version.author = bilbo
    version.parent = parent_version
    assert_equal [bilbo, frodo], version.authors
  end
  
  def test_followers_so_far_defaults_to_empty_lisst
    assert_equal [], PageVersion.new.followers
  end
  
  def test_followers_so_far_includes_parents_followers
    user1 = User.new
    user2 = User.new
    user3 = User.new
    
    version = PageVersion.new
    parent = PageVersion.new
    version.parent = parent
    version.stubs(:followers).returns([user2])
    parent.stubs(:followers_so_far).returns([user1, user3])
    
    assert_equal [user1, user3, user2], version.followers_so_far
  end
  
  def test_page_has_this_version_as_parent
    version = PageVersion.new
    assert_equal version, version.page.parent
  end
  
  def test_page_has_this_versions_children
    children = [PageVersion.new(:text => 'aaaa'), PageVersion.new(:text => 'bbbb')]
    version = PageVersion.new
    version.children = children
    assert_equal children, version.page.versions
  end
  
  def test_has_children_false_if_has_no_children
    assert_equal false, PageVersion.new.has_children?
  end
  
  def test_has_children_true_if_has_children
    version = PageVersion.new
    version.children << PageVersion.new
    assert_equal true, version.has_children?
  end
  
  def test_being_followed_by_defaults_to_false
    assert_equal false, PageVersion.new.being_followed_by(User.new)
  end
  
  def test_being_followed_by_returns_true_if_user_is_the_author
    fred = User.new
    version = PageVersion.new
    version.author = fred
    assert_equal true, version.being_followed_by(fred)
  end
  
  def test_can_stop_following_false_if_isnt_following
    fred = User.new
    version = PageVersion.new
    version.stubs(:being_followed_by).with(fred).returns(false)
    assert_equal false, version.can_stop_following(fred)    
  end
  
  def test_can_stop_following_false_if_user_is_the_author
    fred = User.new
    version = PageVersion.new
    version.author = fred
    version.stubs(:being_followed_by).with(fred).returns(true)
    assert_equal false, version.can_stop_following(fred)    
  end
  
  def test_can_stop_following_true_if_user_is_following
    fred = User.new
    version = PageVersion.new
    version.stubs(:being_followed_by).with(fred).returns(true)
    assert_equal true, version.can_stop_following(fred)    
  end
  
  def test_after_create_calls_on_new_child_for_parent_page
    child = PageVersion.new(:story => @story, :text => 'stuff', :author => @pippin)
    parent = PageVersion.new
    child.parent = parent
    
    parent.expects(:on_new_child).with(child)
    child.save!
  end
  
  def test_after_create_doesn_no_harm_if_has_no_parent_page
    PageVersion.new(:story => @story, :text => 'stuff', :author => @pippin).save
  end
  
  def test_on_new_child_sends_notification_to_author_if_should_notify_author
    version = PageVersion.new
    version.story = @story
    version.author = subscribe_author(@story, true)
    child = PageVersion.new
    NotificationsMailer.expects(:deliver_story_continued).with(@bob, child)
    
    version.on_new_child(child)
  end
   
  def test_on_new_child_does_not_send_notification_to_author_if_shouldnt_notify_author
    version = PageVersion.new
    version.author = @bob
    version.story = @story
    version.author = subscribe_author(@story, false)
    child = PageVersion.new
    NotificationsMailer.expects(:deliver_story_continued).with(@bob, child).never
    
    version.on_new_child(child)
  end

  def test_on_new_child_send_notification_to_subscribed_followers
    version = PageVersion.new(:text => 'stuff', :author => @bob, :story => @story)
    version.save!
    version.followers << subscribe_follower(@story, @frodo, true)
    version.followers << subscribe_follower(@story, @sam, false)
    version.followers << subscribe_follower(@story, @quentin, true)
    subscribe_author(@story, false)
    version.save!
    
    child = PageVersion.new
    NotificationsMailer.expects(:deliver_story_continued).with(@frodo, child)
    NotificationsMailer.expects(:deliver_story_continued).with(@sam, child).never
    NotificationsMailer.expects(:deliver_story_continued).with(@quentin, child)

    version.on_new_child(child)
  end
  
  def test_that_you_cannot_continue_an_end_page
    parent = PageVersion.new(:text => 'the parent page', :author => @bob, :story => @story, :is_end => true)
    version = PageVersion.new(:text => 'some text', :author => @frodo, :story => @story, :parent => parent)
    assert_equal false, version.valid?
    assert_equal 'page was the end of the story.', version.errors[:parent]
  end
  
  def test_tag_list
    version = page_versions(:one)
    version.tag_list = 'fish, banana, corn on the cob'
    assert_equal 'fish, banana, corn on the cob', version.tag_list.to_s
  end
  
  def test_save_updates_story_tags
    version = page_versions(:one)
    story = stories(:first)
  
    version.tag_list = 'fish, banana, corn on the cob'
    version.save!
    assert_equal 'fish, banana, corn on the cob', version.story.tag_list.to_s
    version.reload
    assert_equal 'fish, banana, corn on the cob', version.tag_list.to_s
  
    version.tag_list = 'fish, banana'
    version.save!
    version.reload
    version.story.reload
    assert_equal "banana, fish", version.tag_list.sort.to_s
    assert_equal 'banana, fish', version.story.tag_list.sort.to_s
  
    version.tag_list = 'fish, fish, banana'
    version.save!
    version.reload
    assert_equal 'banana, fish', version.story.tag_list.sort.to_s
  end
  
  def test_can_be_edited_by?_author
    @version.author = @frodo
    assert @version.can_be_edited_by?(@frodo)
  end
  
  def test_cant_be_edited_by_not_author
    @version.author = @frodo
    assert !@version.can_be_edited_by?(@bob)
  end
  
  def test_cant_be_edited_by_nil_user
    assert !@version.can_be_edited_by?(nil)
  end
  
  def test_can_be_edited_by?_admin
    @version.author = @frodo
    @bob.is_admin = true
    assert @version.can_be_edited_by?(@bob)
  end
  
  def test_url_if_parent_is_nil
    @story.stubs(:new_record?).returns(false)
    @story.stubs(:id).returns(15)
    @version.story = @story
    
    assert_equal 'http://test.host/stories/15/parent/0/pages', @version.url
  end
  
  def test_url_if_parent_is_not_nil
    @story.stubs(:new_record?).returns(false)
    @story.stubs(:id).returns(15)
  
    parent = PageVersion.new(:story => @story)
    parent.stubs(:new_record?).returns(false)
    parent.stubs(:id).returns(54)
    
    @version.story = @story
    @version.parent = parent
    
    assert_equal 'http://test.host/stories/15/parent/54/pages', @version.url
  end

end
