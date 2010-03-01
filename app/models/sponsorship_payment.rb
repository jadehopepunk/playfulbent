# == Schema Information
#
# Table name: sponsorship_payments
#
#  id             :integer(4)      not null, primary key
#  sponsorship_id :integer(4)
#  amount_cents   :integer(4)
#  created_at     :datetime
#

class SponsorshipPayment < ActiveRecord::Base
  belongs_to :sponsorship
  validates_presence_of :sponsorship
  
end
