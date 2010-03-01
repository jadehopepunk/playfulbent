# == Schema Information
#
# Table name: product_urls
#
#  id            :integer(4)      not null, primary key
#  original_url  :string(255)
#  affiliate_url :string(255)
#  product_id    :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

require File.dirname(__FILE__) + '/../spec_helper'

describe ProductUrl do

  it "should should prepend http onto original urls without it" do
    product_url = ProductUrl.new(:original_url => "www.someurl.com")
    product_url.original_url.should == "http://www.someurl.com"
  end
  
end
