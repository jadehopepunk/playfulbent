require File.dirname(__FILE__) + '/../test_helper'

class MailingListMessageTest < Test::Unit::TestCase
  fixtures :mailing_list_messages, :yahoo_profiles, :groups, :group_memberships
  
  def setup
    @not_a_member = yahoo_profiles(:not_a_member)
    @craigs_playground = groups(:craigs_playground)
  end

  def test_that_creating_mailing_list_message_creates_group_membership_if_it_doesnt_exist
    message = valid_new_message(:sender_external_profile => @not_a_member)
    message.save!
    
    assert GroupMembership.find(:first, :conditions => {:group_id => @craigs_playground.id, :yahoo_profile_id => @not_a_member.id})
  end
  
  def test_that_creating_mailing_list_message_doesnt_create_group_membership_if_no_sender_profile
    message = valid_new_message(:sender_external_profile => nil)
    message.save!
    
    assert !GroupMembership.find(:first, :conditions => {:group_id => @craigs_playground.id, :yahoo_profile_id => nil})    
  end
  
  def test_that_you_cant_create_two_messages_with_the_same_id
    valid_new_message.save!
    assert !valid_new_message.save
  end
    
  protected
  
    def valid_new_message(options = {})
      attributes = {:subject => 'hi there', :raw_email => 'stuff', :group => @craigs_playground, :message_identifier => 'abc123'}.merge(options)
      MailingListMessage.new(attributes)
    end
        
end
