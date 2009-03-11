# == Schema Information
# Schema version: 258
#
# Table name: sponsorship_payments
#
#  id             :integer(11)   not null, primary key
#  sponsorship_id :integer(11)   
#  amount_cents   :integer(11)   
#  created_at     :datetime      
#

class SponsorshipPayment < ActiveRecord::Base
  belongs_to :sponsorship
  validates_presence_of :sponsorship
  
end
