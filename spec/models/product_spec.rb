require File.dirname(__FILE__) + '/../spec_helper'

describe Product do

  it "should initialise a product url record if given a url string" do
    product = Product.new
    product.url = "http://www.someurl.com"
    
    product.product_urls.length.should == 1
    product.product_urls.first.original_url.should == "http://www.someurl.com"
  end
  
end
