require File.dirname(__FILE__) + '/../spec_helper'

describe ProductUrl do

  it "should should prepend http onto original urls without it" do
    product_url = ProductUrl.new(:original_url => "www.someurl.com")
    product_url.original_url.should == "http://www.someurl.com"
  end
  
end
