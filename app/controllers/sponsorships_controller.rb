require 'paypal'
require 'money'
require 'paypal_extras'

class SponsorshipsController < UserBaseController
  before_filter :login_required, :except => [:notify]
  before_filter :load_user
  
  def new
  end
  
  def submitted
  end
  
  def notify
    Paypal::Notification.ipn_url = AppConfig.paypal_url
    #Paypal::Notification.paypal_cert = File::read("paypal_cert.pem")
    
    notification = Paypal::Notification.new(request.raw_post)

    if notification.acknowledge
      if @user.sponsorship
        result = notify_existing_sponsorship(notification, @user.sponsorship)
      else
        result = notify_new_sponsorship(notification)
      end
      
      NotificationsMailer.deliver_admin_warning("Paypal IPN notification recieved, but unused.", params) unless result
    else
      NotificationsMailer.deliver_admin_warning("Possible failed cracking attempt. Paypal notify was called but acknowledgement failed.", params)
    end

    render :nothing => true
  end
  
protected

  def notify_new_sponsorship(notification)
    if notification.type == Paypal::TransactionType::Subscription::SIGNUP
      @user.sponsorship = Sponsorship.create(:user => @user, :amount_cents => notification.amount.cents)
      @user.sponsorship.make_payment(notification.amount.cents)
      return true
    end
    return false
  end
  
  def notify_existing_sponsorship(notification, sponsorship)
    case notification.type
      when Paypal::TransactionType::Subscription::PAYMENT
        @user.sponsorship.make_payment(notification.amount.cents)
        return true
      when Paypal::TransactionType::Subscription::CANCEL
        if @user.sponsorship
          @user.sponsorship.cancel(Time.now)
          return true
        else
          NotificationsMailer.deliver_admin_warning("Paypal subscription cancelled, but sponsorship not recorded in playfulbent.", params)
        end
      else
    end
    return false
  end

  def load_user
    @user = User.find(params[:user_id])
  end
    
end
