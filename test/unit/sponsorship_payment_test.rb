# == Schema Information
#
# Table name: sponsorship_payments
#
#  id             :integer(4)      not null, primary key
#  sponsorship_id :integer(4)
#  amount_cents   :integer(4)
#  created_at     :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class SponsorshipPaymentTest < Test::Unit::TestCase
  fixtures :sponsorship_payments

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
