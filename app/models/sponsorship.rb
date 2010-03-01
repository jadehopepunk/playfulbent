# == Schema Information
#
# Table name: sponsorships
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  amount_cents :integer(4)
#  created_at   :datetime
#  cancelled_at :datetime
#

class Sponsorship < ActiveRecord::Base
  belongs_to :user
  has_many :payments, :class_name => 'SponsorshipPayment'
  validates_presence_of :user
  
  def make_payment(payment_amount_cents)
    payments.build(:amount_cents => payment_amount_cents)
    save!

    begin
      NotificationsMailer.deliver_new_sponsorship(self) if payments.length == 1
    rescue Net::SMTPSyntaxError
    end
  end
  
  def cancelled?
    !cancelled_at.nil?
  end
  
  def cancel(time)
    raise ArgumentError.new('You must specify a time to cancel a sponsorship') if time.nil?
    self.cancelled_at = time
    save!

    begin
      NotificationsMailer.deliver_sponsorship_cancelled(self)
    rescue Net::SMTPSyntaxError
    end
  end
  
end
