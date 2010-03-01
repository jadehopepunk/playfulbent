# == Schema Information
#
# Table name: dare_challenges
#
#  id                :integer(4)      not null, primary key
#  user_id           :integer(4)
#  subject_id        :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  dare_level        :string(255)     default("flirty")
#  subject_dare_text :text
#  user_dare_text    :text
#  response_added_at :datetime
#  rejected_at       :datetime
#  completed_at      :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class DareChallengeTest < Test::Unit::TestCase
  fixtures :dare_challenges, :users, :email_addresses

  #------------------------------------------------------------
  # SAVE
  #------------------------------------------------------------

  def test_that_creating_challenge_sends_email
    dare_challenge = DareChallenge.new(:subject => users(:pippin), :user => users(:frodo))
    NotificationsMailer.expects(:deliver_new_dare_challenge).with(dare_challenge)
    dare_challenge.save!
  end
  
  def test_that_creating_challenge_fails_if_email_wont_send
    dare_challenge = DareChallenge.new(:subject => users(:pippin), :user => users(:frodo))
    NotificationsMailer.expects(:deliver_new_dare_challenge).with(dare_challenge).raises(Net::SMTPSyntaxError)
    
    dare_challenge.save!
  end
  
  def test_that_rejecting_dare_challenge_sends_email
    dare_challenge = dare_challenges(:sam_challenges_frodo)
    NotificationsMailer.expects(:deliver_dare_challenge_rejected).with(dare_challenge)
    
    dare_challenge.reject
  end
    
  def test_that_rejecting_dare_challenge_doest_mind_mail_error
    dare_challenge = dare_challenges(:sam_challenges_frodo)
    NotificationsMailer.expects(:deliver_dare_challenge_rejected).with(dare_challenge).raises(Net::SMTPSyntaxError)
    
    dare_challenge.reject
  end
  
  def test_that_accepting_dare_challenge_sends_email
    dare_challenge = dare_challenges(:sam_challenges_frodo)
    NotificationsMailer.expects(:deliver_dare_challenge_accepted).with(dare_challenge)
    assert dare_challenge.update_with_subject_response(:subject_dare_text => 'eat my shorts')
  end
  
  def test_that_update_with_user_response_informs_both_parties
    dare_challenge = dare_challenges(:sam_challenges_frodo_with_response)
    NotificationsMailer.expects(:deliver_dare_challenge_dare_received).with(dare_challenge.subject, dare_challenge.user, 'eat my socks', dare_challenge)
    NotificationsMailer.expects(:deliver_dare_challenge_dare_received).with(dare_challenge.user, dare_challenge.subject, 'Eat my shorts!', dare_challenge)
    dare_challenge.update_with_user_response(:user_dare_text => 'eat my socks')
  end

  
end
