# == Schema Information
#
# Table name: dare_rejections
#
#  id                    :integer(4)      not null, primary key
#  dare_challenge_id     :integer(4)
#  user_id               :integer(4)
#  rejected_dare_text    :text
#  rejection_reason_text :text
#  created_at            :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class DareRejectionTest < Test::Unit::TestCase
  fixtures :dare_rejections, :dare_challenges, :users, :email_addresses

  #------------------------------------------------------------
  # SAVE
  #------------------------------------------------------------

  def test_that_creating_dare_rejection_sends_email
    dare_rejection = DareRejection.new
    dare_rejection.dare_challenge = dare_challenges(:sam_challenges_frodo_with_dares)
    dare_rejection.user = users(:sam)
    
    NotificationsMailer.expects(:deliver_dare_rejected).with(dare_rejection).raises(Net::SMTPSyntaxError)
    dare_rejection.save!
  end
  
  def test_that_creating_dare_rejection_for_dare_challenge_clears_dare_challenge_text
    dare_challenge = dare_challenges(:sam_challenges_frodo_with_dares)
    
    dare_rejection = DareRejection.new
    dare_rejection.dare_challenge = dare_challenge
    dare_rejection.user = users(:sam)
    dare_rejection.save!
    dare_challenge.reload
    
    assert_equal nil, dare_challenge.subject_dare_text
    assert_equal "Show me your feet.", dare_challenge.user_dare_text
  end
  
end
