# == Schema Information
#
# Table name: reviews
#
#  id                :integer(4)      not null, primary key
#  user_id           :integer(4)
#  product_id        :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  sexyness_rating   :integer(4)
#  durability_rating :integer(4)
#  cleaning_rating   :integer(4)
#  pleasure_rating   :integer(4)
#  overall_rating    :integer(4)
#  body              :text
#

require File.dirname(__FILE__) + '/../test_helper'

class ReviewTest < Test::Unit::TestCase
  fixtures :reviews, :users, :email_addresses, :products

  ## OWNERS ##

  def test_that_owners_is_just_review_user
    assert_equal [users(:sam)], reviews(:sam_reviews_giantess).owners
  end
  
  ## URL ##
  
  def test_that_url_is_built_with_routes
    assert_equal "http://test.host/reviews/1", reviews(:sam_reviews_giantess).url
  end
  
end
