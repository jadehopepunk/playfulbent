require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  fixtures :comments, :users, :email_addresses, :conversations, :profiles
  
  def setup
    @bilbo = User.new(:nick => 'Bilbo')
    @bilbo.stubs(:new_record?).returns(false)
    @bilbo.stubs(:id).returns(11)
  end

  def test_tells_confirmations_of_create
    conversation = Conversation.new
    comment = Comment.new(:conversation => conversation, :user => User.new, :content => 'valid content')
    conversation.expects(:on_new_comment).with(comment)
    
    comment.save!
  end
  
  def test_subject_returns_subject_from_conversation
    subject = Profile.new
    conversation = Conversation.new(:subject => subject)
    comment = Comment.new(:conversation => conversation)
    
    assert_equal subject, comment.subject
  end
  
  def test_to_rss
    conversation = Conversation.new(:title_override => "The Foxy Conversation")
    conversation.stubs(:id).returns(34)
    conversation.stubs(:new_record?).returns(false)
    
    user = User.new(:nick => 'Bilbo')
    user.stubs(:html_avatar).returns('bilbos avatar')
    
    some_date = Time.now
    expected_description = "The fat brown fox."
    comment = Comment.new(:conversation => conversation, :created_at => some_date, :content => expected_description, :user => user)
    item = comment.to_rss 'http://www.playfulbent.com/'
    
    assert_equal 'http://test.host/conversations/34/comments', item.link
    assert_equal some_date, item.pubDate
    assert_equal 'bilbos avatar The fat brown fox.', item.description
    assert_equal 'The Foxy Conversation - comment by Bilbo', item.title
  end
  
  def test_mark_as_read_creates_comment_reading
    comment = Comment.new
    comment.stubs(:id).returns(12)
    comment.stubs(:new_record?).returns(false)
    CommentReading.stubs(:find).with(:first, :conditions => {:user_id => 11, :comment_id => 12}).returns(nil)
    CommentReading.expects(:create).with(:user => @bilbo, :comment => comment)
    
    comment.mark_as_read(@bilbo)
  end
  
  def test_mark_as_read_doesnt_create_comment_reading_if_it_already_exists
    comment = Comment.new
    comment.stubs(:id).returns(12)
    comment.stubs(:new_record?).returns(false)
    CommentReading.stubs(:find).with(:first, :conditions => {:user_id => 11, :comment_id => 12}).returns(CommentReading.new)
    CommentReading.expects(:create).never
    
    comment.mark_as_read(@bilbo)
  end
  
  def test_that_identical_comments_cant_be_saved_twice
    attributes = {:user => users(:bob), :conversation => conversations(:about_profile_one), :content => 'here is some content'}
    comment1 = Comment.new(attributes)
    comment2 = Comment.new(attributes)
    
    assert comment1.save
    assert !comment2.save
    assert_not_nil comment2.errors[:base]
  end
  
  ## ADD REPLY ##
  
  def test_that_add_reply_makes_reply_a_child_of_this_comment
    reply = Comment.create(:user => users(:frodo), :content => 'stuff', :conversation_id => 1)
    
    comments(:one).add_reply(reply)
    assert_equal comments(:one), reply.parent
  end
  
  def test_that_add_reply_delivers_notification
    reply = Comment.create(:user => users(:frodo), :content => 'stuff', :conversation_id => 1)
    NotificationsMailer.expects(:deliver_new_comment_reply).with(comments(:one), reply)
    comments(:one).add_reply(reply)
  end
  
  def test_that_add_reply_doesnt_deliver_notification_if_parent_user_is_also_an_owner
    parent = comments(:two)
    parent.stubs(:subject_owners).returns([users(:frodo)])
    reply = Comment.create(:user => users(:frodo), :content => 'stuff', :conversation_id => 2)
    NotificationsMailer.expects(:deliver_new_comment_reply).with(parent, reply).never
    parent.add_reply(reply)
  end
      
end
