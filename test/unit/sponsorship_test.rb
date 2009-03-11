require File.dirname(__FILE__) + '/../test_helper'

class SponsorshipTest < Test::Unit::TestCase
  fixtures :sponsorships, :users, :email_addresses
  
  def setup
    @sponsorship = Sponsorship.create(:user => users(:sam))
  end

  def test_make_payment_creates_a_new_payment
    @sponsorship.make_payment(2300)
    assert_equal 1, @sponsorship.payments.length
    assert_equal 2300, @sponsorship.payments.first.amount_cents
  end
  
  def test_make_payment_sends_new_sponsorship_notification_if_is_first_payment
    NotificationsMailer.expects(:deliver_new_sponsorship).with(@sponsorship)
    @sponsorship.make_payment(2300)
  end
  
  def test_make_payment_doesnt_send_new_sponsorship_notification_if_is_not_first_payment
    @sponsorship.make_payment(2300)
    NotificationsMailer.expects(:deliver_new_sponsorship).with(@sponsorship).never
    @sponsorship.make_payment(2300)
  end
  
  def test_cancelled_if_has_cancelled_at
    assert !@sponsorship.cancelled?
    
    @sponsorship.cancelled_at = Time.now
    assert @sponsorship.cancelled?    
  end
  
  def test_cancel_sets_cancelled_at
    time = Time.now
    
    @sponsorship.cancel(time)
    assert_equal time, @sponsorship.cancelled_at
  end
  
  def test_cancel_throws_exception_if_time_is_nil
    assert_raise ArgumentError do
      @sponsorship.cancel(nil)
    end
  end
  
  def test_cancel_sends_cancellation_notification
    NotificationsMailer.expects(:deliver_sponsorship_cancelled).with(@sponsorship)
    @sponsorship.cancel(Time.now)
  end
  
end
