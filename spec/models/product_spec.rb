# == Schema Information
#
# Table name: products
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  type       :string(255)
#

require File.dirname(__FILE__) + '/../spec_helper'

describe Product do

  it "should initialise a product url record if given a url string" do
    product = Product.new
    product.url = "http://www.someurl.com"
    
    product.product_urls.length.should == 1
    product.product_urls.first.original_url.should == "http://www.someurl.com"
  end
  
end
