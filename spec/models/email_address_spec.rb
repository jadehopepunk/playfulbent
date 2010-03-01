# == Schema Information
#
# Table name: email_addresses
#
#  id          :integer(4)      not null, primary key
#  address     :string(255)
#  verified_at :datetime
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

require File.dirname(__FILE__) + '/../spec_helper'

describe EmailAddress do
  before(:each) do
    EmailAddress.destroy_all
    @email_address = EmailAddress.new(:address => 'craig@craigambrose.com')
  end

  it "should be valid" do
    @email_address.should be_valid
  end
end
