require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < Test::Unit::TestCase
  fixtures :messages, :users, :email_addresses
  
  #---------------------------------------------------------------
  # VALIDATION
  #---------------------------------------------------------------

  def test_can_be_saved_if_sender_can_send_to_recipient
    message = valid_new_message
    assert message.save
  end
    
  #---------------------------------------------------------------
  # SAVE
  #---------------------------------------------------------------

  def test_creating_message_sends_notification
    message = valid_new_message
    NotificationsMailer.expects(:deliver_new_message).with(message)
    message.save
  end
  
  def test_updating_message_doesnt_send_notification
    message = valid_new_message
    message.save
    NotificationsMailer.expects(:deliver_new_message).with(message).never
    message.save
  end
  
  def test_creating_message_ensures_interaction
    message = valid_new_message
    InteractionExchangeMessages.expects(:create_if_meets_criteria).with(@sender, @recipient)
    InteractionExchangeMessages.expects(:create_if_meets_criteria).with(@recipient, @sender)
    message.save
  end
  
  #---------------------------------------------------------------
  # POSSIBLE_RECIPIENTS_FOR
  #---------------------------------------------------------------

  def test_that_possible_recipients_for_returns_users_with_two_interactions
    user = users(:sam)
    expected_users = [users(:pippin), users(:frodo)]
    user.stubs(:find_others_with_minimum_interactions_or_admin).with(2).returns(expected_users)
    
    assert_equal expected_users, Message.possible_recipients_for(user)
  end
  
  def test_that_possible_recipients_for_returns_all_users_if_user_is_admin
    result = Message.possible_recipients_for(users(:admin))
    
    assert result
    assert result.is_a?(Array)
    assert result.length > 5
    assert result.include?(users(:frodo))
    assert !result.include?(users(:admin))
  end
  
  protected

    def valid_new_message
      @sender = users(:aaron)
      @recipient = users(:sam)
      Message.stubs(:possible_recipients_for).with(@sender).returns([@recipient])
      Message.new(:sender => @sender, :recipient => @recipient, :subject => 'valid subject', :body => 'valid body')
    end
  
end

