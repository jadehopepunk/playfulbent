require File.dirname(__FILE__) + '/../test_helper'
require 'sponsorships_controller'

# Re-raise errors caught by the controller.
class SponsorshipsController; def rescue_action(e) raise e end; end

class SponsorshipsControllerTest < Test::Unit::TestCase
  fixtures :users, :email_addresses, :sponsorships, :sponsorship_payments
  
  def setup
    @controller = SponsorshipsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @notification = Paypal::Notification.new("")
    Paypal::Notification.stubs(:new).returns(@notification)
  end

  def test_notify_with_failed_acknowledgement_is_logged
    @notification.expects(:acknowledge).returns(false)
    NotificationsMailer.expects(:deliver_admin_warning)
    
    post :notify, :user_id => users(:sam).id
    assert users(:sam).sponsorship.nil?
  end
  
  def test_notify_of_signup_creates_new_sponsorship_and_payment
    @notification.expects(:acknowledge).returns(true)
    @notification.stubs(:type).returns(Paypal::TransactionType::Subscription::SIGNUP)
    @notification.stubs(:amount).returns(Money.us_dollar(1400))
    NotificationsMailer.expects(:deliver_admin_warning).never

    post :notify, :user_id => users(:sam).id
    
    sam = users(:sam)
    sponsorship = sam.sponsorship
    assert sponsorship
    assert_equal 1400, sponsorship.amount_cents
    assert sponsorship.payments
    assert_equal 1, sponsorship.payments.length
  end
  
  def test_notify_payment_adds_payment_to_sponsorship
    @notification.expects(:acknowledge).returns(true)
    @notification.stubs(:type).returns(Paypal::TransactionType::Subscription::PAYMENT)
    @notification.stubs(:amount).returns(Money.us_dollar(1000))
    NotificationsMailer.expects(:deliver_admin_warning).never
    
    post :notify, :user_id => users(:sponsoring_sam).id
    
    sam = users(:sponsoring_sam)
    sponsorship = sam.sponsorship
    assert_equal 2, sponsorship.payments.length
    assert_equal 1000, sponsorship.payments[1].amount_cents
  end
  
  def test_notify_cancel_cancels_sponsorship
    @notification.expects(:acknowledge).returns(true)
    @notification.stubs(:type).returns(Paypal::TransactionType::Subscription::CANCEL)
    @notification.stubs(:params).returns({'subscr_date' => '17:38:34 Mar 01, 2007 PST'})
    NotificationsMailer.expects(:deliver_admin_warning).never
  
    post :notify, :user_id => users(:sponsoring_sam).id
  
    sam = users(:sponsoring_sam)
    assert sam.sponsorship.nil?
    assert_equal 1, sam.sponsorships.length
    assert sam.sponsorships.first.cancelled?
  end
  
  def test_notify_cancel_when_no_sponsorship_exists_notified_admin
    @notification.expects(:acknowledge).returns(true)
    @notification.stubs(:type).returns(Paypal::TransactionType::Subscription::CANCEL)
    @notification.stubs(:params).returns({'subscr_date' => '17:38:34 Mar 01, 2007 PST'})
    NotificationsMailer.expects(:deliver_admin_warning)
  
    post :notify, :user_id => users(:sam).id
  end
  
  
  
end
