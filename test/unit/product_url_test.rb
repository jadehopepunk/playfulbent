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

require File.dirname(__FILE__) + '/../test_helper'

class ProductUrlTest < Test::Unit::TestCase
  fixtures :product_urls

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
