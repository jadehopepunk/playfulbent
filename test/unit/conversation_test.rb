# == Schema Information
#
# Table name: conversations
#
#  id             :integer(4)      not null, primary key
#  title_override :string(255)
#  created_at     :datetime
#  subject_id     :integer(4)
#  subject_type   :string(255)
#

require File.dirname(__FILE__) + '/../test_helper'

class ConversationTest < Test::Unit::TestCase
  fixtures :conversations, :comments, :users, :email_addresses
  
  def test_set_subject_finds_subject_using_class_and_id
    expected_user = User.new(:nick => 'fred')
    User.stubs(:find).with(22).returns(expected_user)
    
    conversation = Conversation.new
    conversation.set_subject(22, 'User')
    assert_equal expected_user, conversation.subject
  end
  
  def test_set_subject_sets_subject_to_nil_if_subject_id_is_nil
    conversation = Conversation.new
    conversation.set_subject(nil, nil)
    assert_equal nil, conversation.subject
  end
  
  def test_requires_title_if_has_no_subject
    conversation = Conversation.new
    conversation.valid?
    assert_equal "can't be blank", conversation.errors[:title]
    assert_equal nil, conversation.errors[:subject]
  end
  
  def test_on_new_comment_notifies_subject_owner
    user = User.new
    subject = Profile.new
    subject.stubs(:owners).returns([user])
    comment = Comment.new(:content => 'valid content')
    conversation = Conversation.new(:subject => subject)
    
    NotificationsMailer.expects(:deliver_new_comment).with(user, comment)
    
    conversation.on_new_comment(comment)
  end
  
  def test_on_new_comment_doesnt_send_notification_if_conversation_has_no_subject
    user = User.new
    comment = Comment.new(:content => 'valid content')
    conversation = Conversation.new()
    
    NotificationsMailer.expects(:deliver_new_comment).with(user, comment).never
    
    conversation.on_new_comment(comment)
  end
    
  def test_title_can_be_computed_from_subject
    subject = Profile.new
    subject.stubs(:owners).returns([User.new(:nick => 'Bilbo')])

    conversation = Conversation.new(:subject => subject)
    assert_equal 'Conversation about Bilbo\'s Profile', conversation.title
  end
  
  def test_subject_url_gets_url_from_subject
    subject = Profile.new
    subject.stubs(:url).returns('http://bilbo.playfulbent.com')

    conversation = Conversation.new(:subject => subject)
    assert_equal 'http://bilbo.playfulbent.com', conversation.subject_url
  end
  
  def test_that_root_comments_returns_roots_but_not_children
    assert_equal [comments(:two)], conversations(:about_profile_one).root_comments
  end

  
end
