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
